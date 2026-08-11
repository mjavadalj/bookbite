import 'package:bookbite/features/discover/data/catalog_cache_store.dart';
import 'package:bookbite/features/discover/data/catalog_detail_cache_store.dart';
import 'package:bookbite/core/data/database/app_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_providers.g.dart';

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final database = AppDatabase.open();
  ref.onDispose(database.close);
  return database;
}

@Riverpod(keepAlive: true)
CatalogCacheStore catalogCacheStore(Ref ref) =>
    CatalogCacheStore(ref.watch(appDatabaseProvider));

@Riverpod(keepAlive: true)
CatalogDetailCacheStore catalogDetailCacheStore(Ref ref) =>
    CatalogDetailCacheStore(ref.watch(appDatabaseProvider));
