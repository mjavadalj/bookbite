import 'package:bookbite/core/data/database/app_database.dart';
import 'package:bookbite/core/data/database/database_providers.dart';
import 'package:bookbite/features/catalog/application/catalog_book_detail_controller.dart';
import 'package:bookbite/features/discover/application/discover_controller.dart';
import 'package:bookbite/features/discover/domain/catalog_book.dart';
import 'package:bookbite/features/discover/domain/catalog_book_detail.dart';
import 'package:bookbite/features/discover/domain/catalog_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('detail Add action saves once and reopens as Saved', () async {
    final database = AppDatabase.memory();
    final catalog = _CatalogRepository();
    final provider = catalogBookDetailControllerProvider(
      'openLibrary',
      'OL1M',
      'search',
    );
    final first = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        catalogRepositoryProvider.overrideWithValue(catalog),
      ],
    );
    addTearDown(first.dispose);

    await first.read(provider.notifier).load('en');
    expect(first.read(provider).saveStatus, PersonalBookSaveStatus.notSaved);

    await first.read(provider.notifier).addToLibrary();
    final saved = first.read(provider);
    expect(saved.saveStatus, PersonalBookSaveStatus.saved);
    expect(saved.personalBookId, isNotNull);

    await first.read(provider.notifier).addToLibrary();
    expect(
      await database.select(database.personalBookEntries).get(),
      hasLength(1),
    );

    final reopened = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        catalogRepositoryProvider.overrideWithValue(catalog),
      ],
    );
    addTearDown(reopened.dispose);
    await reopened.read(provider.notifier).load('en');
    expect(reopened.read(provider).saveStatus, PersonalBookSaveStatus.saved);
    await database.close();
  });
}

class _CatalogRepository implements CatalogRepository {
  @override
  Future<CatalogBookDetail> detail({
    required String provider,
    required String id,
    String? workId,
    required String language,
  }) async => CatalogBookDetail(
    provider: provider,
    id: id,
    editionId: id,
    title: 'A Book',
    authors: const ['An Author'],
    fetchedAt: DateTime.utc(2026, 8, 13),
  );

  @override
  Future<List<CatalogBook>> related({
    required CatalogBookDetail book,
    required String language,
    int limit = 10,
  }) async => const [];

  @override
  Future<CatalogPage> browse({required String language, required int offset}) =>
      throw UnimplementedError();

  @override
  Future<CatalogPage> search({
    required String query,
    required bool isIsbn,
    required String language,
    required int offset,
  }) => throw UnimplementedError();

  @override
  Future<CatalogPage> weekly({required String language}) =>
      throw UnimplementedError();
}
