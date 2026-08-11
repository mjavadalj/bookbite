import 'dart:convert';

import 'package:bookbite/core/data/database/app_database.dart';
import 'package:bookbite/features/discover/domain/catalog_book.dart';
import 'package:bookbite/features/discover/domain/catalog_book_detail.dart';

class CachedCatalogDetail {
  const CachedCatalogDetail({
    required this.detail,
    required this.related,
    required this.lastAccess,
  });

  final CatalogBookDetail detail;
  final List<CatalogBook> related;
  final DateTime lastAccess;
}

class CatalogDetailCacheStore {
  CatalogDetailCacheStore(this._database);

  final AppDatabase _database;

  Future<Map<String, CachedCatalogDetail>> readAll() async {
    final rows = await _database
        .select(_database.catalogDetailCacheEntries)
        .get();
    final result = <String, CachedCatalogDetail>{};
    for (final row in rows) {
      try {
        final payload = jsonDecode(row.payload);
        if (payload is! Map<Object?, Object?>) continue;
        result[row.cacheKey] = CachedCatalogDetail(
          detail: _detailFromJson(payload['detail']),
          related: _booksFromJson(payload['related']),
          lastAccess: DateTime.fromMillisecondsSinceEpoch(
            row.lastAccessAt,
            isUtc: true,
          ),
        );
      } on FormatException {
        // A malformed disposable entry does not affect other entries.
      }
    }
    return result;
  }

  Future<void> replaceAll(Map<String, CachedCatalogDetail> entries) async {
    await _database.transaction(() async {
      await _database.delete(_database.catalogDetailCacheEntries).go();
      for (final entry in entries.entries) {
        await _database
            .into(_database.catalogDetailCacheEntries)
            .insert(
              CatalogDetailCacheEntriesCompanion.insert(
                cacheKey: entry.key,
                payload: jsonEncode({
                  'detail': _detailToJson(entry.value.detail),
                  'related': entry.value.related.map(_bookToJson).toList(),
                }),
                lastAccessAt: entry.value.lastAccess
                    .toUtc()
                    .millisecondsSinceEpoch,
                updatedAt: entry.value.detail.fetchedAt
                    .toUtc()
                    .millisecondsSinceEpoch,
              ),
            );
      }
    });
  }

  Map<String, Object?> _detailToJson(CatalogBookDetail detail) => {
    'provider': detail.provider,
    'id': detail.id,
    'workId': detail.workId,
    'title': detail.title,
    'authors': detail.authors,
    'coverUrl': detail.coverUrl?.toString(),
    'description': detail.description,
    'subjects': detail.subjects,
    'publicationDate': detail.publicationDate,
    'firstPublishedYear': detail.firstPublishedYear,
    'edition': detail.edition,
    'language': detail.language,
    'originalLanguage': detail.originalLanguage,
    'pageCount': detail.pageCount,
    'isbn10': detail.isbn10,
    'isbn13': detail.isbn13,
    'fetchedAt': detail.fetchedAt.toIso8601String(),
  };

  CatalogBookDetail _detailFromJson(Object? raw) {
    if (raw is! Map<Object?, Object?>) {
      throw const FormatException('Invalid cached detail.');
    }
    final provider = raw['provider'];
    final id = raw['id'];
    final title = raw['title'];
    final fetchedAt = raw['fetchedAt'];
    if (provider is! String ||
        id is! String ||
        title is! String ||
        fetchedAt is! String) {
      throw const FormatException('Invalid cached detail identity.');
    }
    return CatalogBookDetail(
      provider: provider,
      id: id,
      workId: raw['workId'] as String?,
      title: title,
      authors: _strings(raw['authors']),
      coverUrl: Uri.tryParse(raw['coverUrl'] as String? ?? ''),
      description: raw['description'] as String?,
      subjects: _strings(raw['subjects']),
      publicationDate: raw['publicationDate'] as String?,
      firstPublishedYear: raw['firstPublishedYear'] as int?,
      edition: raw['edition'] as String?,
      language: raw['language'] as String?,
      originalLanguage: raw['originalLanguage'] as String?,
      pageCount: raw['pageCount'] as int?,
      isbn10: _strings(raw['isbn10']),
      isbn13: _strings(raw['isbn13']),
      fetchedAt: DateTime.parse(fetchedAt).toUtc(),
    );
  }

  List<CatalogBook> _booksFromJson(Object? raw) => raw is List
      ? raw.whereType<Map<Object?, Object?>>().map(_bookFromJson).toList()
      : const [];

  CatalogBook _bookFromJson(Map<Object?, Object?> raw) {
    final provider = raw['provider'];
    final id = raw['id'];
    final title = raw['title'];
    if (provider is! String || id is! String || title is! String) {
      throw const FormatException('Invalid cached related book.');
    }
    return CatalogBook(
      provider: provider,
      id: id,
      title: title,
      workId: raw['workId'] as String?,
      authors: _strings(raw['authors']),
      edition: raw['edition'] as String?,
      language: raw['language'] as String?,
      firstPublishedYear: raw['firstPublishedYear'] as int?,
      isbns: _strings(raw['isbns']),
      coverUrl: Uri.tryParse(raw['coverUrl'] as String? ?? ''),
    );
  }

  Map<String, Object?> _bookToJson(CatalogBook book) => {
    'provider': book.provider,
    'id': book.id,
    'title': book.title,
    'workId': book.workId,
    'authors': book.authors,
    'edition': book.edition,
    'language': book.language,
    'firstPublishedYear': book.firstPublishedYear,
    'isbns': book.isbns,
    'coverUrl': book.coverUrl?.toString(),
  };

  List<String> _strings(Object? raw) =>
      raw is List ? raw.whereType<String>().toList() : const [];
}
