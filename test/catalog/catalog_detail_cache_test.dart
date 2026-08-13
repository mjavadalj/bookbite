import 'package:bookbite/core/data/database/app_database.dart';
import 'package:bookbite/features/discover/data/bounded_catalog_detail_cache.dart';
import 'package:bookbite/features/discover/data/catalog_detail_cache_store.dart';
import 'package:bookbite/features/discover/domain/catalog_book_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('retains the five most recently accessed detail records', () async {
    final database = AppDatabase.memory();
    var clock = DateTime.utc(2026, 1, 1);
    final cache = CatalogDetailCache(
      store: CatalogDetailCacheStore(database),
      now: () => clock,
    );

    for (var index = 0; index < 5; index++) {
      await cache.write(_detail(index));
      clock = clock.add(const Duration(milliseconds: 1));
    }
    await cache.read('openLibrary:OL0M');
    await cache.write(_detail(5));

    expect(await cache.read('openLibrary:OL0M'), isNotNull);
    expect(await cache.read('openLibrary:OL1M'), isNull);
    expect(await cache.read('openLibrary:OL5M'), isNotNull);
    await database.close();
  });

  test(
    'ignores one malformed persisted detail without losing valid entries',
    () async {
      final database = AppDatabase.memory();
      final store = CatalogDetailCacheStore(database);
      final cache = CatalogDetailCache(store: store);
      await cache.write(_detail(1));
      await database
          .into(database.catalogDetailCacheEntries)
          .insert(
            CatalogDetailCacheEntriesCompanion.insert(
              cacheKey: 'openLibrary:OL2M',
              payload: '{"detail":{"provider":12}}',
              lastAccessAt: 1,
              updatedAt: 1,
            ),
          );

      final restored = CatalogDetailCache(store: store);
      expect(await restored.read('openLibrary:OL1M'), isNotNull);
      expect(await restored.read('openLibrary:OL2M'), isNull);
      await database.close();
    },
  );
}

CatalogBookDetail _detail(int index) => CatalogBookDetail(
  provider: 'openLibrary',
  id: 'OL${index}M',
  title: 'Book $index',
  fetchedAt: DateTime.utc(2026, 1, 1),
);
