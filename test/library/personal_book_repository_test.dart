import 'dart:io';

import 'package:bookbite/core/data/database/app_database.dart';
import 'package:bookbite/features/discover/data/bounded_catalog_detail_cache.dart';
import 'package:bookbite/features/discover/data/catalog_detail_cache_store.dart';
import 'package:bookbite/features/discover/domain/catalog_book_detail.dart';
import 'package:bookbite/features/library/data/drift_personal_book_repository.dart';
import 'package:bookbite/features/library/domain/personal_book.dart';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

void main() {
  test(
    'catalog import persists a permanent offline metadata snapshot',
    () async {
      final directory = await Directory.systemTemp.createTemp('bookbite-book-');
      final file = File(
        '${directory.path}${Platform.pathSeparator}book.sqlite',
      );
      try {
        final firstDatabase = AppDatabase(
          DatabaseConnection(NativeDatabase(file)),
        );
        final firstRepository = DriftPersonalBookRepository(firstDatabase);
        await firstRepository.importCatalogBook(_book(id: 'personal-1'));
        await firstDatabase.close();

        final reopenedDatabase = AppDatabase(
          DatabaseConnection(NativeDatabase(file)),
        );
        final restored = await DriftPersonalBookRepository(
          reopenedDatabase,
        ).findById('personal-1');

        expect(restored?.title, 'The Left Hand of Darkness');
        expect(restored?.snapshot.description, 'A permanent description');
        expect(restored?.snapshot.isbn13, ['9780441478125']);
        expect(restored?.provenance?.bookId, 'OL1M');
        await reopenedDatabase.close();
      } finally {
        if (await directory.exists()) await directory.delete(recursive: true);
      }
    },
  );

  test('repeated import returns the existing PersonalBook', () async {
    final database = AppDatabase.memory();
    final repository = DriftPersonalBookRepository(database);

    final first = await repository.importCatalogBook(_book(id: 'personal-1'));
    final duplicate = await repository.importCatalogBook(
      _book(id: 'personal-2'),
    );
    final rows = await database.select(database.personalBookEntries).get();

    expect(duplicate.id, first.id);
    expect(rows, hasLength(1));
    await database.close();
  });

  test('different catalog editions create separate PersonalBooks', () async {
    final database = AppDatabase.memory();
    final repository = DriftPersonalBookRepository(database);

    await repository.importCatalogBook(_book(id: 'personal-1'));
    await repository.importCatalogBook(
      _book(id: 'personal-2', catalogBookId: 'OL2M'),
    );

    final rows = await database.select(database.personalBookEntries).get();
    expect(
      rows.map((row) => row.id),
      containsAll(['personal-1', 'personal-2']),
    );
    await database.close();
  });

  test('failed import transaction leaves no partial PersonalBook', () async {
    final database = AppDatabase.memory();
    final repository = DriftPersonalBookRepository(database);
    await repository.importCatalogBook(_book(id: 'personal-1'));

    await expectLater(
      repository.importCatalogBook(
        _book(id: 'personal-1', catalogBookId: 'OL2M'),
      ),
      throwsA(isA<sqlite.SqliteException>()),
    );
    final rows = await database.select(database.personalBookEntries).get();

    expect(rows, hasLength(1));
    expect(rows.single.catalogBookId, 'OL1M');
    await database.close();
  });

  test('catalog detail eviction cannot delete PersonalBooks', () async {
    final database = AppDatabase.memory();
    final repository = DriftPersonalBookRepository(database);
    await repository.importCatalogBook(_book(id: 'personal-1'));
    final cache = CatalogDetailCache(store: CatalogDetailCacheStore(database));

    for (var index = 0; index < 6; index++) {
      await cache.write(
        CatalogBookDetail(
          provider: 'openLibrary',
          id: 'OL${index}M',
          title: 'Disposable $index',
          fetchedAt: DateTime.utc(2026, 8, 13),
        ),
      );
    }

    expect(await repository.findById('personal-1'), isNotNull);
    expect(
      await database.select(database.catalogDetailCacheEntries).get(),
      hasLength(5),
    );
    await database.close();
  });

  test(
    'schema version two migrates without losing catalog cache tables',
    () async {
      final directory = await Directory.systemTemp.createTemp('bookbite-v2-');
      final file = File(
        '${directory.path}${Platform.pathSeparator}migration.sqlite',
      );
      try {
        final oldDatabase = sqlite.sqlite3.open(file.path);
        oldDatabase.execute('''
        CREATE TABLE catalog_cache_entries (
          cache_key TEXT NOT NULL PRIMARY KEY,
          payload TEXT NOT NULL,
          last_access_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL
        );
        CREATE TABLE catalog_detail_cache_entries (
          cache_key TEXT NOT NULL PRIMARY KEY,
          payload TEXT NOT NULL,
          last_access_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL
        );
        PRAGMA user_version = 2;
      ''');
        oldDatabase.close();

        final database = AppDatabase(DatabaseConnection(NativeDatabase(file)));
        expect(
          await database.select(database.personalBookEntries).get(),
          isEmpty,
        );
        expect(
          await database.select(database.catalogCacheEntries).get(),
          isEmpty,
        );
        await database.close();
      } finally {
        if (await directory.exists()) await directory.delete(recursive: true);
      }
    },
  );
}

NewPersonalBook _book({required String id, String catalogBookId = 'OL1M'}) =>
    NewPersonalBook(
      id: id,
      title: 'The Left Hand of Darkness',
      authors: const ['Ursula K. Le Guin'],
      createdAt: DateTime.utc(2026, 8, 13),
      provenance: CatalogProvenance(
        provider: 'openLibrary',
        bookId: catalogBookId,
        workId: 'OL10W',
      ),
      snapshot: const CatalogMetadataSnapshot(
        title: 'The Left Hand of Darkness',
        authors: ['Ursula K. Le Guin'],
        description: 'A permanent description',
        edition: 'First edition',
        language: 'eng',
        pageCount: 304,
        isbn13: ['9780441478125'],
      ),
    );
