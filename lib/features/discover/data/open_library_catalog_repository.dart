import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bookbite/features/discover/domain/catalog_book.dart';
import 'package:bookbite/features/discover/domain/catalog_book_detail.dart';
import 'package:bookbite/features/discover/domain/catalog_repository.dart';

abstract interface class CatalogHttpClient {
  Future<CatalogHttpResponse> get(
    Uri uri, {
    required Map<String, String> headers,
  });
}

class CatalogHttpResponse {
  const CatalogHttpResponse({required this.statusCode, required this.bytes});
  final int statusCode;
  final List<int> bytes;
}

class DartCatalogHttpClient implements CatalogHttpClient {
  DartCatalogHttpClient({HttpClient? client})
    : _client = client ?? HttpClient();
  final HttpClient _client;

  @override
  Future<CatalogHttpResponse> get(
    Uri uri, {
    required Map<String, String> headers,
  }) async {
    final request = await _client.getUrl(uri);
    headers.forEach(request.headers.set);
    final response = await request.close();
    final bytes = await response.fold<List<int>>(
      <int>[],
      (all, chunk) => all..addAll(chunk),
    );
    return CatalogHttpResponse(statusCode: response.statusCode, bytes: bytes);
  }
}

class OpenLibraryCatalogRepository implements CatalogRepository {
  OpenLibraryCatalogRepository({required this._client, required String contact})
    : _contact = contact.trim();

  final CatalogHttpClient _client;
  final String _contact;
  DateTime _nextRequestAt = DateTime.fromMillisecondsSinceEpoch(0);

  static const _host = 'openlibrary.org';
  static const _fields =
      'key,title,author_name,edition_key,cover_i,language,first_publish_year,isbn';

  @override
  Future<CatalogPage> weekly({required String language}) async {
    final page = await _search(
      'language:eng',
      language: 'en',
      offset: 0,
      sort: 'trending',
    );
    return CatalogPage(
      books: page.books.take(10).toList(growable: false),
      hasMore: false,
      source: page.source,
      lastUpdated: page.lastUpdated,
    );
  }

  @override
  Future<CatalogPage> browse({required String language, required int offset}) {
    const subjects =
        '(subject:philosophy OR subject:fiction OR subject:history OR subject:biography OR subject:self_help) AND language:eng';
    return _search(subjects, language: 'en', offset: offset, sort: 'trending');
  }

  @override
  Future<CatalogPage> search({
    required String query,
    required bool isIsbn,
    required String language,
    required int offset,
  }) {
    final literal = query.replaceAll('"', r'\"');
    return _search(
      '${isIsbn ? 'isbn:$literal' : '"$literal"'} AND language:eng',
      language: 'en',
      offset: offset,
    );
  }

  @override
  Future<CatalogBookDetail> detail({
    required String provider,
    required String id,
    String? workId,
    required String language,
  }) async {
    const preferredEditionLanguage = 'eng';
    if (provider != 'openLibrary' ||
        !_validCatalogKey(id) ||
        (workId != null && !_validCatalogKey(workId))) {
      throw const CatalogFailure(CatalogFailureKind.invalidResponse);
    }

    Map<String, Object?> edition = const {};
    Map<String, Object?> work = const {};
    if (id.endsWith('M')) {
      edition = await _get(Uri.https(_host, '/books/$id.json'));
      final referencedWork = _keyFromReferences(edition['works']);
      final resolvedWorkId = workId ?? referencedWork;
      if (resolvedWorkId != null && resolvedWorkId.endsWith('W')) {
        work = await _get(Uri.https(_host, '/works/$resolvedWorkId.json'));
      }
    } else {
      work = await _get(Uri.https(_host, '/works/$id.json'));
      final editions = await _get(
        Uri.https(_host, '/works/$id/editions.json', {'limit': '10'}),
      );
      edition = _representativeEdition(
        editions['entries'],
        preferredEditionLanguage,
      );
    }

    final title = _text(edition['title']) ?? _text(work['title']);
    if (title == null) {
      throw const CatalogFailure(CatalogFailureKind.invalidResponse);
    }

    final resolvedWorkId =
        workId ??
        _keyFromReferences(edition['works']) ??
        (id.endsWith('W') ? id : null);
    final mappedEditionId = id.endsWith('M') ? id : _catalogKey(edition['key']);
    final authors = await _authors(edition['authors'] ?? work['authors']);
    final covers = _ints(edition['covers']);
    final workCovers = _ints(work['covers']);
    final identifiers = _identifiers(edition['identifiers']);
    final isbn10 = _uniqueStrings([
      ...identifiers['isbn_10'] ?? const [],
      ..._texts(edition['isbn_10']),
    ]).take(5).toList(growable: false);
    final isbn13 = _uniqueStrings([
      ...identifiers['isbn_13'] ?? const [],
      ..._texts(edition['isbn_13']),
    ]).take(5).toList(growable: false);
    final publishDate = _text(edition['publish_date']);
    final firstPublished = _firstYear(
      _text(work['first_publish_date']) ?? _text(edition['first_publish_date']),
    );

    return CatalogBookDetail(
      provider: provider,
      id: id,
      editionId: mappedEditionId?.endsWith('M') == true
          ? mappedEditionId
          : null,
      workId: resolvedWorkId,
      title: title,
      authors: authors,
      coverUrl: _coverUrl((covers.isEmpty ? workCovers : covers).firstOrNull),
      description: _description(work['description'] ?? edition['description']),
      subjects: _uniqueStrings([
        ..._texts(work['subjects']),
        ..._texts(edition['subjects']),
      ]).take(12).toList(growable: false),
      publicationDate: publishDate,
      firstPublishedYear: firstPublished,
      edition: _text(edition['edition_name']),
      language: _language(edition['languages'] ?? work['languages']),
      originalLanguage: _language(work['original_languages']),
      pageCount: _positiveInt(edition['number_of_pages']),
      isbn10: isbn10,
      isbn13: isbn13,
      fetchedAt: DateTime.now().toUtc(),
    );
  }

  @override
  Future<List<CatalogBook>> related({
    required CatalogBookDetail book,
    required String language,
    int limit = 10,
  }) async {
    if (book.provider != 'openLibrary' || book.subjects.isEmpty) {
      return const [];
    }
    final subjects = book.subjects
        .map(_normalizeSubject)
        .whereType<String>()
        .take(3)
        .toList(growable: false);
    if (subjects.isEmpty) return const [];

    final query = subjects.map((subject) => 'subject:"$subject"').join(' OR ');
    final page = await _search(
      '($query) AND language:eng',
      language: 'en',
      offset: 0,
    );
    final excluded = {book.id, if (book.workId != null) book.workId!};
    final unique = <String, CatalogBook>{};
    for (final candidate in page.books) {
      if (excluded.contains(candidate.id) ||
          (candidate.workId != null && excluded.contains(candidate.workId))) {
        continue;
      }
      unique.putIfAbsent(candidate.identity, () => candidate);
      if (unique.length >= limit) break;
    }
    return unique.values.toList(growable: false);
  }

  Future<CatalogPage> _search(
    String query, {
    required String language,
    required int offset,
    String? sort,
  }) async {
    final params = <String, String>{
      'q': query,
      'fields': _fields,
      'lang': language,
      'limit': '20',
      'offset': '$offset',
      'sort': ?sort,
    };
    final data = await _get(Uri.https(_host, '/search.json', params));
    final raw = data['docs'];
    final rawCount = raw is List ? raw.length : 0;
    final books = _mapDocuments(raw).toList(growable: false);
    final total = data['numFound'] is num
        ? (data['numFound'] as num).toInt()
        : null;
    return CatalogPage(
      books: books,
      hasMore: rawCount == 20 && (total == null || offset + rawCount < total),
      nextOffset: offset + rawCount,
      total: total,
      source: CatalogSource.network,
      lastUpdated: DateTime.now().toUtc(),
    );
  }

  Future<Map<String, Object?>> _get(Uri uri) async {
    if (_contact.isEmpty) {
      throw const CatalogFailure(CatalogFailureKind.configuration);
    }
    final now = DateTime.now();
    final delay = _nextRequestAt.difference(now);
    if (!delay.isNegative) await Future<void>.delayed(delay);
    _nextRequestAt = DateTime.now().add(const Duration(milliseconds: 334));
    try {
      final response = await _client
          .get(
            uri.replace(
              queryParameters: {...uri.queryParameters, 'email': _contact},
            ),
            headers: {
              'User-Agent': 'BookBite/0.1 ($_contact)',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 429) {
        throw const CatalogFailure(CatalogFailureKind.rateLimited);
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw const CatalogFailure(CatalogFailureKind.unavailable);
      }
      if (response.bytes.length > 2 * 1024 * 1024) {
        throw const CatalogFailure(CatalogFailureKind.invalidResponse);
      }
      final decoded = jsonDecode(utf8.decode(response.bytes));
      if (decoded is! Map) {
        throw const CatalogFailure(CatalogFailureKind.invalidResponse);
      }
      return decoded.map((key, value) => MapEntry('$key', value));
    } on CatalogFailure {
      rethrow;
    } on TimeoutException {
      throw const CatalogFailure(CatalogFailureKind.timeout);
    } on SocketException {
      throw const CatalogFailure(CatalogFailureKind.offline);
    } on FormatException {
      throw const CatalogFailure(CatalogFailureKind.invalidResponse);
    } catch (_) {
      throw const CatalogFailure(CatalogFailureKind.unexpected);
    }
  }

  Iterable<CatalogBook> _mapDocuments(Object? source) sync* {
    if (source is! List) return;
    for (final item in source.take(200)) {
      if (item is! Map) continue;
      final workKey = _catalogKey(item['key']);
      final editions = _texts(item['edition_key']);
      final id = editions.firstWhere(
        (candidate) => RegExp(r'^OL\d+M$').hasMatch(candidate),
        orElse: () => workKey ?? '',
      );
      final title = _text(item['title']);
      if (id.isEmpty || title == null || title.isEmpty) continue;
      final coverId = item['cover_i'];
      yield CatalogBook(
        provider: 'openLibrary',
        id: id,
        workId: workKey,
        title: title,
        authors: _texts(item['author_name']),
        language: _texts(item['language']).firstOrNull,
        firstPublishedYear: item['first_publish_year'] is num
            ? (item['first_publish_year'] as num).toInt()
            : null,
        isbns: _texts(item['isbn']).take(3).toList(growable: false),
        coverUrl: coverId is num
            ? Uri.https(
                'covers.openlibrary.org',
                '/b/id/${coverId.toInt()}-M.jpg',
              )
            : null,
      );
    }
  }

  Future<List<String>> _authors(Object? raw) async {
    if (raw is! List) return const [];
    final names = <String>[];
    final ids = <String>{};
    for (final item in raw.take(8)) {
      if (item is! Map) continue;
      final direct = _text(item['name']);
      if (direct != null) {
        names.add(direct);
        continue;
      }
      final key = _text(item['key']);
      if (key == null || !RegExp(r'^/authors/OL\d+A$').hasMatch(key)) {
        continue;
      }
      final authorId = key.substring('/authors/'.length);
      if (!ids.add(authorId)) continue;
      try {
        final author = await _get(Uri.https(_host, '/authors/$authorId.json'));
        final name = _text(author['name']);
        if (name != null) names.add(name);
      } on CatalogFailure {
        // A missing author does not invalidate otherwise usable detail.
      }
    }
    return _uniqueStrings(names).take(8).toList(growable: false);
  }

  Map<String, Object?> _representativeEdition(Object? raw, String language) {
    if (raw is! List) return const {};
    final entries = raw.whereType<Map<Object?, Object?>>();
    Map<String, Object?>? preferredLanguage;
    Map<String, Object?>? covered;
    Map<String, Object?>? fallback;
    for (final entry in entries) {
      final normalized = entry.map((key, value) => MapEntry('$key', value));
      final id = _catalogKey(normalized['key']);
      if (id == null || !id.endsWith('M')) continue;
      normalized['key'] = id;
      final hasCover = _ints(normalized['covers']).isNotEmpty;
      final languages = _language(normalized['languages']);
      fallback ??= normalized;
      if (languages == language) {
        preferredLanguage ??= normalized;
        if (hasCover) return normalized;
      } else if (hasCover) {
        covered ??= normalized;
      }
    }
    return preferredLanguage ?? covered ?? fallback ?? const {};
  }

  Map<String, List<String>> _identifiers(Object? raw) {
    if (raw is! Map) return const {};
    final result = <String, List<String>>{};
    for (final entry in raw.entries) {
      result['${entry.key}'] = _texts(entry.value);
    }
    return result;
  }

  String? _description(Object? raw) {
    final value = raw is Map ? raw['value'] : raw;
    if (value is! String) return null;
    final cleaned = value
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]'), '')
        .replaceAll('\r\n', '\n')
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .join('\n\n')
        .trim();
    return cleaned.isEmpty || cleaned.runes.length > 500 ? null : cleaned;
  }

  String? _language(Object? raw) {
    if (raw is! List) return null;
    for (final entry in raw) {
      final key = entry is Map ? _text(entry['key']) : null;
      final value = key?.split('/').last;
      if (value != null && value.isNotEmpty) return value;
    }
    return null;
  }

  String? _normalizeSubject(String raw) {
    final normalized = raw
        .replaceAll(RegExp(r'[\x00-\x1F\x7F]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    return normalized.isEmpty || normalized.length > 80 ? null : normalized;
  }

  String? _keyFromReferences(Object? raw) {
    if (raw is! List || raw.isEmpty) return null;
    final first = raw.first;
    return first is Map ? _catalogKey(first['key']) : null;
  }

  Uri? _coverUrl(int? coverId) => coverId == null
      ? null
      : Uri.https('covers.openlibrary.org', '/b/id/$coverId-L.jpg');

  int? _positiveInt(Object? raw) =>
      raw is num && raw.toInt() > 0 ? raw.toInt() : null;

  int? _firstYear(String? raw) {
    if (raw == null) return null;
    final match = RegExp(r'\b(1[0-9]{3}|20[0-9]{2})\b').firstMatch(raw);
    return match == null ? null : int.tryParse(match.group(0)!);
  }

  bool _validCatalogKey(String value) => RegExp(r'^OL\d+[MW]$').hasMatch(value);

  String? _catalogKey(Object? value) {
    final text = _text(value);
    if (text == null) return null;
    final match = RegExp(r'(OL\d+[MW])$').firstMatch(text);
    return match?.group(1);
  }

  String? _text(Object? value) {
    if (value is! String) return null;
    final normalized = value
        .replaceAll(RegExp(r'[\x00-\x1F\x7F]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    return normalized.isEmpty || normalized.runes.length > 500
        ? null
        : normalized;
  }

  List<String> _texts(Object? values) => values is List
      ? values.map(_text).whereType<String>().take(32).toList(growable: false)
      : const [];

  List<int> _ints(Object? values) => values is List
      ? values
            .whereType<num>()
            .map((value) => value.toInt())
            .toList(growable: false)
      : const [];

  List<String> _uniqueStrings(Iterable<String> values) {
    final seen = <String>{};
    return values.where((value) => seen.add(value)).toList(growable: false);
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
