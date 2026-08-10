import 'dart:convert';

import 'package:bookbite/core/data/database/app_database.dart';
import 'package:bookbite/features/discover/domain/catalog_book.dart';
import 'package:bookbite/features/discover/domain/catalog_repository.dart';

class CachedCatalogPage {
  const CachedCatalogPage({required this.page, required this.lastAccess});

  final CatalogPage page;
  final DateTime lastAccess;
}

class CatalogCacheStore {
  CatalogCacheStore(this._database);

  final AppDatabase _database;

  Future<Map<String, CachedCatalogPage>> readAll() async {
    final rows = await (_database.select(_database.catalogCacheEntries).get());
    final result = <String, CachedCatalogPage>{};
    for (final row in rows) {
      try {
        result[row.cacheKey] = CachedCatalogPage(
          page: _pageFromJson(jsonDecode(row.payload)),
          lastAccess: DateTime.fromMillisecondsSinceEpoch(
            row.lastAccessAt,
            isUtc: true,
          ),
        );
      } on FormatException {
        // A malformed disposable entry is omitted; other entries survive.
      }
    }
    return result;
  }

  Future<void> replaceAll(Map<String, CachedCatalogPage> pages) async {
    await _database.delete(_database.catalogCacheEntries).go();
    for (final entry in pages.entries) {
      await _database
          .into(_database.catalogCacheEntries)
          .insert(
            CatalogCacheEntriesCompanion.insert(
              cacheKey: entry.key,
              payload: jsonEncode(_pageToJson(entry.value.page)),
              lastAccessAt: entry.value.lastAccess
                  .toUtc()
                  .millisecondsSinceEpoch,
              updatedAt:
                  entry.value.page.lastUpdated
                      ?.toUtc()
                      .millisecondsSinceEpoch ??
                  DateTime.now().toUtc().millisecondsSinceEpoch,
            ),
          );
    }
  }

  Map<String, Object?> _pageToJson(CatalogPage page) => {
    'books': page.books.map(_bookToJson).toList(growable: false),
    'hasMore': page.hasMore,
    'nextOffset': page.nextOffset,
    'total': page.total,
    'lastUpdated': page.lastUpdated?.toIso8601String(),
  };

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

  CatalogPage _pageFromJson(Object? raw) {
    if (raw is! Map<Object?, Object?> || raw['books'] is! List<Object?>) {
      throw const FormatException('Invalid cached catalog page.');
    }
    return CatalogPage(
      books: (raw['books'] as List<Object?>)
          .whereType<Map<Object?, Object?>>()
          .map(_bookFromJson)
          .toList(growable: false),
      hasMore: raw['hasMore'] == true,
      nextOffset: raw['nextOffset'] as int?,
      total: raw['total'] as int?,
      source: CatalogSource.staleCache,
      lastUpdated: DateTime.tryParse(raw['lastUpdated'] as String? ?? ''),
    );
  }

  CatalogBook _bookFromJson(Map<Object?, Object?> raw) {
    final provider = raw['provider'];
    final id = raw['id'];
    final title = raw['title'];
    if (provider is! String || id is! String || title is! String) {
      throw const FormatException('Invalid cached catalog book.');
    }
    return CatalogBook(
      provider: provider,
      id: id,
      title: title,
      workId: raw['workId'] as String?,
      authors: (raw['authors'] as List<Object?>? ?? const <Object?>[])
          .whereType<String>()
          .toList(growable: false),
      edition: raw['edition'] as String?,
      language: raw['language'] as String?,
      firstPublishedYear: raw['firstPublishedYear'] as int?,
      isbns: (raw['isbns'] as List<Object?>? ?? const <Object?>[])
          .whereType<String>()
          .toList(growable: false),
      coverUrl: Uri.tryParse(raw['coverUrl'] as String? ?? ''),
    );
  }
}
