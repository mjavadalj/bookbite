import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bookbite/features/discover/domain/catalog_book.dart';
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

/// Open Library implementation. The contact is loaded from local dotenv
/// configuration and injected into the repository.
class OpenLibraryCatalogRepository implements CatalogRepository {
  OpenLibraryCatalogRepository({
    required CatalogHttpClient client,
    required String contact,
  }) : _client = client,
       _contact = contact.trim();

  final CatalogHttpClient _client;
  final String _contact;
  DateTime _nextRequestAt = DateTime.fromMillisecondsSinceEpoch(0);

  static const _host = 'openlibrary.org';
  static const _fields =
      'key,title,author_name,edition_key,cover_i,language,first_publish_year,isbn';

  @override
  Future<CatalogPage> weekly({required String language}) async {
    final data = await _get(
      Uri.https(_host, '/trending/weekly.json', {'limit': '10'}),
    );
    final books = _mapDocuments(data['works']).take(10).toList(growable: false);
    return CatalogPage(
      books: books,
      hasMore: false,
      source: CatalogSource.network,
      lastUpdated: DateTime.now().toUtc(),
    );
  }

  @override
  Future<CatalogPage> browse({required String language, required int offset}) {
    const subjects =
        '(subject:philosophy OR subject:fiction OR subject:history OR subject:biography OR subject:self_help)';
    return _search(
      subjects,
      language: language,
      offset: offset,
      sort: 'trending',
    );
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
      isIsbn ? 'isbn:$literal' : '"$literal"',
      language: language,
      offset: offset,
    );
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
      if (sort != null) 'sort': sort,
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
    if (_contact.isEmpty)
      throw const CatalogFailure(CatalogFailureKind.configuration);
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
      if (response.statusCode == 429)
        throw const CatalogFailure(CatalogFailureKind.rateLimited);
      if (response.statusCode < 200 || response.statusCode >= 300)
        throw const CatalogFailure(CatalogFailureKind.unavailable);
      if (response.bytes.length > 2 * 1024 * 1024)
        throw const CatalogFailure(CatalogFailureKind.invalidResponse);
      final decoded = jsonDecode(utf8.decode(response.bytes));
      if (decoded is! Map)
        throw const CatalogFailure(CatalogFailureKind.invalidResponse);
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
      final key = _text(item['key']);
      final editions = _texts(item['edition_key']);
      final id = editions.firstWhere(
        (candidate) => RegExp(r'^OL\d+M$').hasMatch(candidate),
        orElse: () => key ?? '',
      );
      final title = _text(item['title']);
      if (id.isEmpty || title == null || title.isEmpty) continue;
      final coverId = item['cover_i'];
      yield CatalogBook(
        provider: 'openLibrary',
        id: id,
        workId: key,
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

  String? _text(Object? value) {
    if (value is! String) return null;
    final normalized = value.replaceAll(RegExp(r'[\x00-\x1F\x7F]'), '').trim();
    return normalized.isEmpty || normalized.runes.length > 500
        ? null
        : normalized;
  }

  List<String> _texts(Object? values) => values is List
      ? values.map(_text).whereType<String>().take(8).toList(growable: false)
      : const [];
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
