import 'dart:io';

import 'package:bookbite/core/data/database/app_database.dart';
import 'package:bookbite/features/discover/data/catalog_cache_store.dart';
import 'package:bookbite/features/discover/domain/catalog_book.dart';
import 'package:bookbite/features/discover/domain/catalog_repository.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('database can be created and reopened at schema version one', () async {
    final directory = await Directory.systemTemp.createTemp('bookbite-db-');
    final file = File('${directory.path}${Platform.pathSeparator}test.sqlite');
    try {
      final first = AppDatabase(DatabaseConnection(NativeDatabase(file)));
      await first.select(first.catalogCacheEntries).get();
      await first.close();

      final second = AppDatabase(DatabaseConnection(NativeDatabase(file)));
      final rows = await second.select(second.catalogCacheEntries).get();
      expect(rows, hasLength(1));
      await second.close();
    } finally {
      await directory.delete(recursive: true);
    }
  });

  test(
    'catalog cache preserves valid summaries and source provenance',
    () async {
      final database = AppDatabase.memory();
      final store = CatalogCacheStore(database);
      final book = CatalogBook(
        provider: 'openLibrary',
        id: 'OL1M',
        title: 'A saved book',
        authors: const ['Author'],
      );
      final page = CatalogPage(
        books: [book],
        hasMore: false,
        source: CatalogSource.network,
        lastUpdated: DateTime.utc(2026, 1, 1),
      );

      await store.replaceAll({
        'browse:en:0': CachedCatalogPage(
          page: page,
          lastAccess: DateTime.utc(2026, 1, 2),
        ),
      });
      final restored = await store.readAll();

      expect(restored['browse:en:0']?.page.books.single.title, 'A saved book');
      expect(restored['browse:en:0']?.page.source, CatalogSource.staleCache);
      await database.close();
    },
  );
}
