// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CatalogCacheEntriesTable extends CatalogCacheEntries
    with TableInfo<$CatalogCacheEntriesTable, CatalogCacheEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogCacheEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cacheKeyMeta = const VerificationMeta(
    'cacheKey',
  );
  @override
  late final GeneratedColumn<String> cacheKey = GeneratedColumn<String>(
    'cache_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastAccessAtMeta = const VerificationMeta(
    'lastAccessAt',
  );
  @override
  late final GeneratedColumn<int> lastAccessAt = GeneratedColumn<int>(
    'last_access_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    cacheKey,
    payload,
    lastAccessAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalog_cache_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<CatalogCacheEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cache_key')) {
      context.handle(
        _cacheKeyMeta,
        cacheKey.isAcceptableOrUnknown(data['cache_key']!, _cacheKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_cacheKeyMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('last_access_at')) {
      context.handle(
        _lastAccessAtMeta,
        lastAccessAt.isAcceptableOrUnknown(
          data['last_access_at']!,
          _lastAccessAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastAccessAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cacheKey};
  @override
  CatalogCacheEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogCacheEntry(
      cacheKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cache_key'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      lastAccessAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_access_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CatalogCacheEntriesTable createAlias(String alias) {
    return $CatalogCacheEntriesTable(attachedDatabase, alias);
  }
}

class CatalogCacheEntry extends DataClass
    implements Insertable<CatalogCacheEntry> {
  final String cacheKey;
  final String payload;
  final int lastAccessAt;
  final int updatedAt;
  const CatalogCacheEntry({
    required this.cacheKey,
    required this.payload,
    required this.lastAccessAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cache_key'] = Variable<String>(cacheKey);
    map['payload'] = Variable<String>(payload);
    map['last_access_at'] = Variable<int>(lastAccessAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  CatalogCacheEntriesCompanion toCompanion(bool nullToAbsent) {
    return CatalogCacheEntriesCompanion(
      cacheKey: Value(cacheKey),
      payload: Value(payload),
      lastAccessAt: Value(lastAccessAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CatalogCacheEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogCacheEntry(
      cacheKey: serializer.fromJson<String>(json['cacheKey']),
      payload: serializer.fromJson<String>(json['payload']),
      lastAccessAt: serializer.fromJson<int>(json['lastAccessAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cacheKey': serializer.toJson<String>(cacheKey),
      'payload': serializer.toJson<String>(payload),
      'lastAccessAt': serializer.toJson<int>(lastAccessAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  CatalogCacheEntry copyWith({
    String? cacheKey,
    String? payload,
    int? lastAccessAt,
    int? updatedAt,
  }) => CatalogCacheEntry(
    cacheKey: cacheKey ?? this.cacheKey,
    payload: payload ?? this.payload,
    lastAccessAt: lastAccessAt ?? this.lastAccessAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CatalogCacheEntry copyWithCompanion(CatalogCacheEntriesCompanion data) {
    return CatalogCacheEntry(
      cacheKey: data.cacheKey.present ? data.cacheKey.value : this.cacheKey,
      payload: data.payload.present ? data.payload.value : this.payload,
      lastAccessAt: data.lastAccessAt.present
          ? data.lastAccessAt.value
          : this.lastAccessAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatalogCacheEntry(')
          ..write('cacheKey: $cacheKey, ')
          ..write('payload: $payload, ')
          ..write('lastAccessAt: $lastAccessAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(cacheKey, payload, lastAccessAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatalogCacheEntry &&
          other.cacheKey == this.cacheKey &&
          other.payload == this.payload &&
          other.lastAccessAt == this.lastAccessAt &&
          other.updatedAt == this.updatedAt);
}

class CatalogCacheEntriesCompanion extends UpdateCompanion<CatalogCacheEntry> {
  final Value<String> cacheKey;
  final Value<String> payload;
  final Value<int> lastAccessAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const CatalogCacheEntriesCompanion({
    this.cacheKey = const Value.absent(),
    this.payload = const Value.absent(),
    this.lastAccessAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CatalogCacheEntriesCompanion.insert({
    required String cacheKey,
    required String payload,
    required int lastAccessAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : cacheKey = Value(cacheKey),
       payload = Value(payload),
       lastAccessAt = Value(lastAccessAt),
       updatedAt = Value(updatedAt);
  static Insertable<CatalogCacheEntry> custom({
    Expression<String>? cacheKey,
    Expression<String>? payload,
    Expression<int>? lastAccessAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (cacheKey != null) 'cache_key': cacheKey,
      if (payload != null) 'payload': payload,
      if (lastAccessAt != null) 'last_access_at': lastAccessAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CatalogCacheEntriesCompanion copyWith({
    Value<String>? cacheKey,
    Value<String>? payload,
    Value<int>? lastAccessAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return CatalogCacheEntriesCompanion(
      cacheKey: cacheKey ?? this.cacheKey,
      payload: payload ?? this.payload,
      lastAccessAt: lastAccessAt ?? this.lastAccessAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cacheKey.present) {
      map['cache_key'] = Variable<String>(cacheKey.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (lastAccessAt.present) {
      map['last_access_at'] = Variable<int>(lastAccessAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatalogCacheEntriesCompanion(')
          ..write('cacheKey: $cacheKey, ')
          ..write('payload: $payload, ')
          ..write('lastAccessAt: $lastAccessAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CatalogCacheEntriesTable catalogCacheEntries =
      $CatalogCacheEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [catalogCacheEntries];
}

typedef $$CatalogCacheEntriesTableCreateCompanionBuilder =
    CatalogCacheEntriesCompanion Function({
      required String cacheKey,
      required String payload,
      required int lastAccessAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$CatalogCacheEntriesTableUpdateCompanionBuilder =
    CatalogCacheEntriesCompanion Function({
      Value<String> cacheKey,
      Value<String> payload,
      Value<int> lastAccessAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$CatalogCacheEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $CatalogCacheEntriesTable> {
  $$CatalogCacheEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get cacheKey => $composableBuilder(
    column: $table.cacheKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastAccessAt => $composableBuilder(
    column: $table.lastAccessAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CatalogCacheEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CatalogCacheEntriesTable> {
  $$CatalogCacheEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get cacheKey => $composableBuilder(
    column: $table.cacheKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastAccessAt => $composableBuilder(
    column: $table.lastAccessAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CatalogCacheEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CatalogCacheEntriesTable> {
  $$CatalogCacheEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get cacheKey =>
      $composableBuilder(column: $table.cacheKey, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<int> get lastAccessAt => $composableBuilder(
    column: $table.lastAccessAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CatalogCacheEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CatalogCacheEntriesTable,
          CatalogCacheEntry,
          $$CatalogCacheEntriesTableFilterComposer,
          $$CatalogCacheEntriesTableOrderingComposer,
          $$CatalogCacheEntriesTableAnnotationComposer,
          $$CatalogCacheEntriesTableCreateCompanionBuilder,
          $$CatalogCacheEntriesTableUpdateCompanionBuilder,
          (
            CatalogCacheEntry,
            BaseReferences<
              _$AppDatabase,
              $CatalogCacheEntriesTable,
              CatalogCacheEntry
            >,
          ),
          CatalogCacheEntry,
          PrefetchHooks Function()
        > {
  $$CatalogCacheEntriesTableTableManager(
    _$AppDatabase db,
    $CatalogCacheEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatalogCacheEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatalogCacheEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CatalogCacheEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> cacheKey = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int> lastAccessAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CatalogCacheEntriesCompanion(
                cacheKey: cacheKey,
                payload: payload,
                lastAccessAt: lastAccessAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String cacheKey,
                required String payload,
                required int lastAccessAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CatalogCacheEntriesCompanion.insert(
                cacheKey: cacheKey,
                payload: payload,
                lastAccessAt: lastAccessAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CatalogCacheEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CatalogCacheEntriesTable,
      CatalogCacheEntry,
      $$CatalogCacheEntriesTableFilterComposer,
      $$CatalogCacheEntriesTableOrderingComposer,
      $$CatalogCacheEntriesTableAnnotationComposer,
      $$CatalogCacheEntriesTableCreateCompanionBuilder,
      $$CatalogCacheEntriesTableUpdateCompanionBuilder,
      (
        CatalogCacheEntry,
        BaseReferences<
          _$AppDatabase,
          $CatalogCacheEntriesTable,
          CatalogCacheEntry
        >,
      ),
      CatalogCacheEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CatalogCacheEntriesTableTableManager get catalogCacheEntries =>
      $$CatalogCacheEntriesTableTableManager(_db, _db.catalogCacheEntries);
}
