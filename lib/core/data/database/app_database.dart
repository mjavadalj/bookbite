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

@DriftDatabase(
  tables: [CatalogCacheEntries, CatalogDetailCacheEntries, PersonalBookEntries],
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
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      if (from < 2) await migrator.createTable(catalogDetailCacheEntries);
      if (from < 3) await migrator.createTable(personalBookEntries);
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
