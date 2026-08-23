import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class CatalogDetailCacheEntries extends Table {
  TextColumn get cacheKey => text()();
  TextColumn get payload => text()();
  IntColumn get lastAccessAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {cacheKey};
}

class CatalogCacheEntries extends Table {
  TextColumn get cacheKey => text()();
  TextColumn get payload => text()();
  IntColumn get lastAccessAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {cacheKey};
}

class PersonalBookEntries extends Table {
  @override
  String get tableName => 'personal_books';

  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get authorsJson => text()();
  TextColumn get snapshotJson => text()();
  TextColumn get catalogProvider => text().nullable()();
  TextColumn get catalogBookId => text().nullable()();
  TextColumn get catalogWorkId => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  IntColumn get archivedAt => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {catalogProvider, catalogBookId},
  ];
}

class ReadingCycleEntries extends Table {
  @override
  String get tableName => 'reading_cycles';

  TextColumn get id => text()();
  TextColumn get personalBookId =>
      text().references(PersonalBookEntries, #id)();
  TextColumn get status => text()();
  IntColumn get startedAt => integer()();
  IntColumn get endedAt => integer().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ReadingSessionEntries extends Table {
  @override
  String get tableName => 'reading_sessions';

  TextColumn get id => text()();
  IntColumn get startedAt => integer()();
  IntColumn get endedAt => integer().nullable()();
  TextColumn get personalBookId =>
      text().nullable().references(PersonalBookEntries, #id)();
  TextColumn get readingCycleId =>
      text().nullable().references(ReadingCycleEntries, #id)();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class BiteEntries extends Table {
  @override
  String get tableName => 'bites';

  TextColumn get id => text()();
  TextColumn get sourceKind => text()();
  TextColumn get extractionStatus => text()();
  TextColumn get extractedText => text().nullable()();
  TextColumn get tagsJson => text().withDefault(const Constant('[]'))();
  TextColumn get readingSessionId =>
      text().nullable().references(ReadingSessionEntries, #id)();
  TextColumn get personalBookId =>
      text().nullable().references(PersonalBookEntries, #id)();
  TextColumn get readingCycleId =>
      text().nullable().references(ReadingCycleEntries, #id)();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ManagedMediaEntries extends Table {
  @override
  String get tableName => 'managed_media';

  TextColumn get id => text()();
  TextColumn get biteId => text().unique().references(BiteEntries, #id)();
  TextColumn get kind => text()();
  TextColumn get reference => text()();
  IntColumn get byteSize => integer()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ExtractionJobEntries extends Table {
  @override
  String get tableName => 'extraction_jobs';

  TextColumn get id => text()();
  TextColumn get biteId => text().unique().references(BiteEntries, #id)();
  TextColumn get kind => text()();
  TextColumn get status => text()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get errorCode => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    CatalogCacheEntries,
    CatalogDetailCacheEntries,
    PersonalBookEntries,
    ReadingCycleEntries,
    ReadingSessionEntries,
    BiteEntries,
    ManagedMediaEntries,
    ExtractionJobEntries,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  factory AppDatabase.open() => AppDatabase(
    LazyDatabase(() async {
      final directory = await getApplicationSupportDirectory();
      final file = File(
        '${directory.path}${Platform.pathSeparator}bookbite.sqlite',
      );
      return NativeDatabase.createInBackground(file);
    }),
  );

  factory AppDatabase.memory() => AppDatabase(NativeDatabase.memory());

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      if (from < 2) await migrator.createTable(catalogDetailCacheEntries);
      if (from < 3) await migrator.createTable(personalBookEntries);
      if (from < 4) {
        await migrator.createTable(readingCycleEntries);
        await migrator.createTable(readingSessionEntries);
        await migrator.createTable(biteEntries);
        await migrator.createTable(managedMediaEntries);
        await migrator.createTable(extractionJobEntries);
        await customStatement(
          'CREATE UNIQUE INDEX IF NOT EXISTS one_active_reading_session '
          'ON reading_sessions ((1)) WHERE ended_at IS NULL',
        );
      }
      if (from < 5) {
        await migrator.addColumn(biteEntries, biteEntries.tagsJson);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      await customStatement(
        'CREATE UNIQUE INDEX IF NOT EXISTS one_active_reading_session '
        'ON reading_sessions ((1)) WHERE ended_at IS NULL',
      );
    },
  );
}
