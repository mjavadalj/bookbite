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

class $CatalogDetailCacheEntriesTable extends CatalogDetailCacheEntries
    with TableInfo<$CatalogDetailCacheEntriesTable, CatalogDetailCacheEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogDetailCacheEntriesTable(this.attachedDatabase, [this._alias]);
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
  static const String $name = 'catalog_detail_cache_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<CatalogDetailCacheEntry> instance, {
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
  CatalogDetailCacheEntry map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogDetailCacheEntry(
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
  $CatalogDetailCacheEntriesTable createAlias(String alias) {
    return $CatalogDetailCacheEntriesTable(attachedDatabase, alias);
  }
}

class CatalogDetailCacheEntry extends DataClass
    implements Insertable<CatalogDetailCacheEntry> {
  final String cacheKey;
  final String payload;
  final int lastAccessAt;
  final int updatedAt;
  const CatalogDetailCacheEntry({
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

  CatalogDetailCacheEntriesCompanion toCompanion(bool nullToAbsent) {
    return CatalogDetailCacheEntriesCompanion(
      cacheKey: Value(cacheKey),
      payload: Value(payload),
      lastAccessAt: Value(lastAccessAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CatalogDetailCacheEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogDetailCacheEntry(
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

  CatalogDetailCacheEntry copyWith({
    String? cacheKey,
    String? payload,
    int? lastAccessAt,
    int? updatedAt,
  }) => CatalogDetailCacheEntry(
    cacheKey: cacheKey ?? this.cacheKey,
    payload: payload ?? this.payload,
    lastAccessAt: lastAccessAt ?? this.lastAccessAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CatalogDetailCacheEntry copyWithCompanion(
    CatalogDetailCacheEntriesCompanion data,
  ) {
    return CatalogDetailCacheEntry(
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
    return (StringBuffer('CatalogDetailCacheEntry(')
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
      (other is CatalogDetailCacheEntry &&
          other.cacheKey == this.cacheKey &&
          other.payload == this.payload &&
          other.lastAccessAt == this.lastAccessAt &&
          other.updatedAt == this.updatedAt);
}

class CatalogDetailCacheEntriesCompanion
    extends UpdateCompanion<CatalogDetailCacheEntry> {
  final Value<String> cacheKey;
  final Value<String> payload;
  final Value<int> lastAccessAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const CatalogDetailCacheEntriesCompanion({
    this.cacheKey = const Value.absent(),
    this.payload = const Value.absent(),
    this.lastAccessAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CatalogDetailCacheEntriesCompanion.insert({
    required String cacheKey,
    required String payload,
    required int lastAccessAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : cacheKey = Value(cacheKey),
       payload = Value(payload),
       lastAccessAt = Value(lastAccessAt),
       updatedAt = Value(updatedAt);
  static Insertable<CatalogDetailCacheEntry> custom({
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

  CatalogDetailCacheEntriesCompanion copyWith({
    Value<String>? cacheKey,
    Value<String>? payload,
    Value<int>? lastAccessAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return CatalogDetailCacheEntriesCompanion(
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
    return (StringBuffer('CatalogDetailCacheEntriesCompanion(')
          ..write('cacheKey: $cacheKey, ')
          ..write('payload: $payload, ')
          ..write('lastAccessAt: $lastAccessAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PersonalBookEntriesTable extends PersonalBookEntries
    with TableInfo<$PersonalBookEntriesTable, PersonalBookEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonalBookEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorsJsonMeta = const VerificationMeta(
    'authorsJson',
  );
  @override
  late final GeneratedColumn<String> authorsJson = GeneratedColumn<String>(
    'authors_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _snapshotJsonMeta = const VerificationMeta(
    'snapshotJson',
  );
  @override
  late final GeneratedColumn<String> snapshotJson = GeneratedColumn<String>(
    'snapshot_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _catalogProviderMeta = const VerificationMeta(
    'catalogProvider',
  );
  @override
  late final GeneratedColumn<String> catalogProvider = GeneratedColumn<String>(
    'catalog_provider',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _catalogBookIdMeta = const VerificationMeta(
    'catalogBookId',
  );
  @override
  late final GeneratedColumn<String> catalogBookId = GeneratedColumn<String>(
    'catalog_book_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _catalogWorkIdMeta = const VerificationMeta(
    'catalogWorkId',
  );
  @override
  late final GeneratedColumn<String> catalogWorkId = GeneratedColumn<String>(
    'catalog_work_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
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
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<int> archivedAt = GeneratedColumn<int>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    authorsJson,
    snapshotJson,
    catalogProvider,
    catalogBookId,
    catalogWorkId,
    createdAt,
    updatedAt,
    archivedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'personal_books';
  @override
  VerificationContext validateIntegrity(
    Insertable<PersonalBookEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('authors_json')) {
      context.handle(
        _authorsJsonMeta,
        authorsJson.isAcceptableOrUnknown(
          data['authors_json']!,
          _authorsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_authorsJsonMeta);
    }
    if (data.containsKey('snapshot_json')) {
      context.handle(
        _snapshotJsonMeta,
        snapshotJson.isAcceptableOrUnknown(
          data['snapshot_json']!,
          _snapshotJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_snapshotJsonMeta);
    }
    if (data.containsKey('catalog_provider')) {
      context.handle(
        _catalogProviderMeta,
        catalogProvider.isAcceptableOrUnknown(
          data['catalog_provider']!,
          _catalogProviderMeta,
        ),
      );
    }
    if (data.containsKey('catalog_book_id')) {
      context.handle(
        _catalogBookIdMeta,
        catalogBookId.isAcceptableOrUnknown(
          data['catalog_book_id']!,
          _catalogBookIdMeta,
        ),
      );
    }
    if (data.containsKey('catalog_work_id')) {
      context.handle(
        _catalogWorkIdMeta,
        catalogWorkId.isAcceptableOrUnknown(
          data['catalog_work_id']!,
          _catalogWorkIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {catalogProvider, catalogBookId},
  ];
  @override
  PersonalBookEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersonalBookEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      authorsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}authors_json'],
      )!,
      snapshotJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}snapshot_json'],
      )!,
      catalogProvider: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}catalog_provider'],
      ),
      catalogBookId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}catalog_book_id'],
      ),
      catalogWorkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}catalog_work_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}archived_at'],
      ),
    );
  }

  @override
  $PersonalBookEntriesTable createAlias(String alias) {
    return $PersonalBookEntriesTable(attachedDatabase, alias);
  }
}

class PersonalBookEntry extends DataClass
    implements Insertable<PersonalBookEntry> {
  final String id;
  final String title;
  final String authorsJson;
  final String snapshotJson;
  final String? catalogProvider;
  final String? catalogBookId;
  final String? catalogWorkId;
  final int createdAt;
  final int updatedAt;
  final int? archivedAt;
  const PersonalBookEntry({
    required this.id,
    required this.title,
    required this.authorsJson,
    required this.snapshotJson,
    this.catalogProvider,
    this.catalogBookId,
    this.catalogWorkId,
    required this.createdAt,
    required this.updatedAt,
    this.archivedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['authors_json'] = Variable<String>(authorsJson);
    map['snapshot_json'] = Variable<String>(snapshotJson);
    if (!nullToAbsent || catalogProvider != null) {
      map['catalog_provider'] = Variable<String>(catalogProvider);
    }
    if (!nullToAbsent || catalogBookId != null) {
      map['catalog_book_id'] = Variable<String>(catalogBookId);
    }
    if (!nullToAbsent || catalogWorkId != null) {
      map['catalog_work_id'] = Variable<String>(catalogWorkId);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<int>(archivedAt);
    }
    return map;
  }

  PersonalBookEntriesCompanion toCompanion(bool nullToAbsent) {
    return PersonalBookEntriesCompanion(
      id: Value(id),
      title: Value(title),
      authorsJson: Value(authorsJson),
      snapshotJson: Value(snapshotJson),
      catalogProvider: catalogProvider == null && nullToAbsent
          ? const Value.absent()
          : Value(catalogProvider),
      catalogBookId: catalogBookId == null && nullToAbsent
          ? const Value.absent()
          : Value(catalogBookId),
      catalogWorkId: catalogWorkId == null && nullToAbsent
          ? const Value.absent()
          : Value(catalogWorkId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
    );
  }

  factory PersonalBookEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersonalBookEntry(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      authorsJson: serializer.fromJson<String>(json['authorsJson']),
      snapshotJson: serializer.fromJson<String>(json['snapshotJson']),
      catalogProvider: serializer.fromJson<String?>(json['catalogProvider']),
      catalogBookId: serializer.fromJson<String?>(json['catalogBookId']),
      catalogWorkId: serializer.fromJson<String?>(json['catalogWorkId']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      archivedAt: serializer.fromJson<int?>(json['archivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'authorsJson': serializer.toJson<String>(authorsJson),
      'snapshotJson': serializer.toJson<String>(snapshotJson),
      'catalogProvider': serializer.toJson<String?>(catalogProvider),
      'catalogBookId': serializer.toJson<String?>(catalogBookId),
      'catalogWorkId': serializer.toJson<String?>(catalogWorkId),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'archivedAt': serializer.toJson<int?>(archivedAt),
    };
  }

  PersonalBookEntry copyWith({
    String? id,
    String? title,
    String? authorsJson,
    String? snapshotJson,
    Value<String?> catalogProvider = const Value.absent(),
    Value<String?> catalogBookId = const Value.absent(),
    Value<String?> catalogWorkId = const Value.absent(),
    int? createdAt,
    int? updatedAt,
    Value<int?> archivedAt = const Value.absent(),
  }) => PersonalBookEntry(
    id: id ?? this.id,
    title: title ?? this.title,
    authorsJson: authorsJson ?? this.authorsJson,
    snapshotJson: snapshotJson ?? this.snapshotJson,
    catalogProvider: catalogProvider.present
        ? catalogProvider.value
        : this.catalogProvider,
    catalogBookId: catalogBookId.present
        ? catalogBookId.value
        : this.catalogBookId,
    catalogWorkId: catalogWorkId.present
        ? catalogWorkId.value
        : this.catalogWorkId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
  );
  PersonalBookEntry copyWithCompanion(PersonalBookEntriesCompanion data) {
    return PersonalBookEntry(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      authorsJson: data.authorsJson.present
          ? data.authorsJson.value
          : this.authorsJson,
      snapshotJson: data.snapshotJson.present
          ? data.snapshotJson.value
          : this.snapshotJson,
      catalogProvider: data.catalogProvider.present
          ? data.catalogProvider.value
          : this.catalogProvider,
      catalogBookId: data.catalogBookId.present
          ? data.catalogBookId.value
          : this.catalogBookId,
      catalogWorkId: data.catalogWorkId.present
          ? data.catalogWorkId.value
          : this.catalogWorkId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersonalBookEntry(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('authorsJson: $authorsJson, ')
          ..write('snapshotJson: $snapshotJson, ')
          ..write('catalogProvider: $catalogProvider, ')
          ..write('catalogBookId: $catalogBookId, ')
          ..write('catalogWorkId: $catalogWorkId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    authorsJson,
    snapshotJson,
    catalogProvider,
    catalogBookId,
    catalogWorkId,
    createdAt,
    updatedAt,
    archivedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonalBookEntry &&
          other.id == this.id &&
          other.title == this.title &&
          other.authorsJson == this.authorsJson &&
          other.snapshotJson == this.snapshotJson &&
          other.catalogProvider == this.catalogProvider &&
          other.catalogBookId == this.catalogBookId &&
          other.catalogWorkId == this.catalogWorkId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.archivedAt == this.archivedAt);
}

class PersonalBookEntriesCompanion extends UpdateCompanion<PersonalBookEntry> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> authorsJson;
  final Value<String> snapshotJson;
  final Value<String?> catalogProvider;
  final Value<String?> catalogBookId;
  final Value<String?> catalogWorkId;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> archivedAt;
  final Value<int> rowid;
  const PersonalBookEntriesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.authorsJson = const Value.absent(),
    this.snapshotJson = const Value.absent(),
    this.catalogProvider = const Value.absent(),
    this.catalogBookId = const Value.absent(),
    this.catalogWorkId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PersonalBookEntriesCompanion.insert({
    required String id,
    required String title,
    required String authorsJson,
    required String snapshotJson,
    this.catalogProvider = const Value.absent(),
    this.catalogBookId = const Value.absent(),
    this.catalogWorkId = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       authorsJson = Value(authorsJson),
       snapshotJson = Value(snapshotJson),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PersonalBookEntry> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? authorsJson,
    Expression<String>? snapshotJson,
    Expression<String>? catalogProvider,
    Expression<String>? catalogBookId,
    Expression<String>? catalogWorkId,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? archivedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (authorsJson != null) 'authors_json': authorsJson,
      if (snapshotJson != null) 'snapshot_json': snapshotJson,
      if (catalogProvider != null) 'catalog_provider': catalogProvider,
      if (catalogBookId != null) 'catalog_book_id': catalogBookId,
      if (catalogWorkId != null) 'catalog_work_id': catalogWorkId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PersonalBookEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? authorsJson,
    Value<String>? snapshotJson,
    Value<String?>? catalogProvider,
    Value<String?>? catalogBookId,
    Value<String?>? catalogWorkId,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? archivedAt,
    Value<int>? rowid,
  }) {
    return PersonalBookEntriesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      authorsJson: authorsJson ?? this.authorsJson,
      snapshotJson: snapshotJson ?? this.snapshotJson,
      catalogProvider: catalogProvider ?? this.catalogProvider,
      catalogBookId: catalogBookId ?? this.catalogBookId,
      catalogWorkId: catalogWorkId ?? this.catalogWorkId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      archivedAt: archivedAt ?? this.archivedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (authorsJson.present) {
      map['authors_json'] = Variable<String>(authorsJson.value);
    }
    if (snapshotJson.present) {
      map['snapshot_json'] = Variable<String>(snapshotJson.value);
    }
    if (catalogProvider.present) {
      map['catalog_provider'] = Variable<String>(catalogProvider.value);
    }
    if (catalogBookId.present) {
      map['catalog_book_id'] = Variable<String>(catalogBookId.value);
    }
    if (catalogWorkId.present) {
      map['catalog_work_id'] = Variable<String>(catalogWorkId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<int>(archivedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonalBookEntriesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('authorsJson: $authorsJson, ')
          ..write('snapshotJson: $snapshotJson, ')
          ..write('catalogProvider: $catalogProvider, ')
          ..write('catalogBookId: $catalogBookId, ')
          ..write('catalogWorkId: $catalogWorkId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReadingCycleEntriesTable extends ReadingCycleEntries
    with TableInfo<$ReadingCycleEntriesTable, ReadingCycleEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadingCycleEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _personalBookIdMeta = const VerificationMeta(
    'personalBookId',
  );
  @override
  late final GeneratedColumn<String> personalBookId = GeneratedColumn<String>(
    'personal_book_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES personal_books (id)',
    ),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<int> startedAt = GeneratedColumn<int>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<int> endedAt = GeneratedColumn<int>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
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
    id,
    personalBookId,
    status,
    startedAt,
    endedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reading_cycles';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReadingCycleEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('personal_book_id')) {
      context.handle(
        _personalBookIdMeta,
        personalBookId.isAcceptableOrUnknown(
          data['personal_book_id']!,
          _personalBookIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_personalBookIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReadingCycleEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReadingCycleEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      personalBookId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}personal_book_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ended_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ReadingCycleEntriesTable createAlias(String alias) {
    return $ReadingCycleEntriesTable(attachedDatabase, alias);
  }
}

class ReadingCycleEntry extends DataClass
    implements Insertable<ReadingCycleEntry> {
  final String id;
  final String personalBookId;
  final String status;
  final int startedAt;
  final int? endedAt;
  final int createdAt;
  final int updatedAt;
  const ReadingCycleEntry({
    required this.id,
    required this.personalBookId,
    required this.status,
    required this.startedAt,
    this.endedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['personal_book_id'] = Variable<String>(personalBookId);
    map['status'] = Variable<String>(status);
    map['started_at'] = Variable<int>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<int>(endedAt);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  ReadingCycleEntriesCompanion toCompanion(bool nullToAbsent) {
    return ReadingCycleEntriesCompanion(
      id: Value(id),
      personalBookId: Value(personalBookId),
      status: Value(status),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ReadingCycleEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReadingCycleEntry(
      id: serializer.fromJson<String>(json['id']),
      personalBookId: serializer.fromJson<String>(json['personalBookId']),
      status: serializer.fromJson<String>(json['status']),
      startedAt: serializer.fromJson<int>(json['startedAt']),
      endedAt: serializer.fromJson<int?>(json['endedAt']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'personalBookId': serializer.toJson<String>(personalBookId),
      'status': serializer.toJson<String>(status),
      'startedAt': serializer.toJson<int>(startedAt),
      'endedAt': serializer.toJson<int?>(endedAt),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  ReadingCycleEntry copyWith({
    String? id,
    String? personalBookId,
    String? status,
    int? startedAt,
    Value<int?> endedAt = const Value.absent(),
    int? createdAt,
    int? updatedAt,
  }) => ReadingCycleEntry(
    id: id ?? this.id,
    personalBookId: personalBookId ?? this.personalBookId,
    status: status ?? this.status,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ReadingCycleEntry copyWithCompanion(ReadingCycleEntriesCompanion data) {
    return ReadingCycleEntry(
      id: data.id.present ? data.id.value : this.id,
      personalBookId: data.personalBookId.present
          ? data.personalBookId.value
          : this.personalBookId,
      status: data.status.present ? data.status.value : this.status,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReadingCycleEntry(')
          ..write('id: $id, ')
          ..write('personalBookId: $personalBookId, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    personalBookId,
    status,
    startedAt,
    endedAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadingCycleEntry &&
          other.id == this.id &&
          other.personalBookId == this.personalBookId &&
          other.status == this.status &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ReadingCycleEntriesCompanion extends UpdateCompanion<ReadingCycleEntry> {
  final Value<String> id;
  final Value<String> personalBookId;
  final Value<String> status;
  final Value<int> startedAt;
  final Value<int?> endedAt;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const ReadingCycleEntriesCompanion({
    this.id = const Value.absent(),
    this.personalBookId = const Value.absent(),
    this.status = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReadingCycleEntriesCompanion.insert({
    required String id,
    required String personalBookId,
    required String status,
    required int startedAt,
    this.endedAt = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       personalBookId = Value(personalBookId),
       status = Value(status),
       startedAt = Value(startedAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ReadingCycleEntry> custom({
    Expression<String>? id,
    Expression<String>? personalBookId,
    Expression<String>? status,
    Expression<int>? startedAt,
    Expression<int>? endedAt,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (personalBookId != null) 'personal_book_id': personalBookId,
      if (status != null) 'status': status,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReadingCycleEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? personalBookId,
    Value<String>? status,
    Value<int>? startedAt,
    Value<int?>? endedAt,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return ReadingCycleEntriesCompanion(
      id: id ?? this.id,
      personalBookId: personalBookId ?? this.personalBookId,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (personalBookId.present) {
      map['personal_book_id'] = Variable<String>(personalBookId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<int>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<int>(endedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
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
    return (StringBuffer('ReadingCycleEntriesCompanion(')
          ..write('id: $id, ')
          ..write('personalBookId: $personalBookId, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReadingSessionEntriesTable extends ReadingSessionEntries
    with TableInfo<$ReadingSessionEntriesTable, ReadingSessionEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadingSessionEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<int> startedAt = GeneratedColumn<int>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<int> endedAt = GeneratedColumn<int>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _personalBookIdMeta = const VerificationMeta(
    'personalBookId',
  );
  @override
  late final GeneratedColumn<String> personalBookId = GeneratedColumn<String>(
    'personal_book_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES personal_books (id)',
    ),
  );
  static const VerificationMeta _readingCycleIdMeta = const VerificationMeta(
    'readingCycleId',
  );
  @override
  late final GeneratedColumn<String> readingCycleId = GeneratedColumn<String>(
    'reading_cycle_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES reading_cycles (id)',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
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
    id,
    startedAt,
    endedAt,
    personalBookId,
    readingCycleId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reading_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReadingSessionEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('personal_book_id')) {
      context.handle(
        _personalBookIdMeta,
        personalBookId.isAcceptableOrUnknown(
          data['personal_book_id']!,
          _personalBookIdMeta,
        ),
      );
    }
    if (data.containsKey('reading_cycle_id')) {
      context.handle(
        _readingCycleIdMeta,
        readingCycleId.isAcceptableOrUnknown(
          data['reading_cycle_id']!,
          _readingCycleIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReadingSessionEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReadingSessionEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ended_at'],
      ),
      personalBookId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}personal_book_id'],
      ),
      readingCycleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reading_cycle_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ReadingSessionEntriesTable createAlias(String alias) {
    return $ReadingSessionEntriesTable(attachedDatabase, alias);
  }
}

class ReadingSessionEntry extends DataClass
    implements Insertable<ReadingSessionEntry> {
  final String id;
  final int startedAt;
  final int? endedAt;
  final String? personalBookId;
  final String? readingCycleId;
  final int createdAt;
  final int updatedAt;
  const ReadingSessionEntry({
    required this.id,
    required this.startedAt,
    this.endedAt,
    this.personalBookId,
    this.readingCycleId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['started_at'] = Variable<int>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<int>(endedAt);
    }
    if (!nullToAbsent || personalBookId != null) {
      map['personal_book_id'] = Variable<String>(personalBookId);
    }
    if (!nullToAbsent || readingCycleId != null) {
      map['reading_cycle_id'] = Variable<String>(readingCycleId);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  ReadingSessionEntriesCompanion toCompanion(bool nullToAbsent) {
    return ReadingSessionEntriesCompanion(
      id: Value(id),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      personalBookId: personalBookId == null && nullToAbsent
          ? const Value.absent()
          : Value(personalBookId),
      readingCycleId: readingCycleId == null && nullToAbsent
          ? const Value.absent()
          : Value(readingCycleId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ReadingSessionEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReadingSessionEntry(
      id: serializer.fromJson<String>(json['id']),
      startedAt: serializer.fromJson<int>(json['startedAt']),
      endedAt: serializer.fromJson<int?>(json['endedAt']),
      personalBookId: serializer.fromJson<String?>(json['personalBookId']),
      readingCycleId: serializer.fromJson<String?>(json['readingCycleId']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'startedAt': serializer.toJson<int>(startedAt),
      'endedAt': serializer.toJson<int?>(endedAt),
      'personalBookId': serializer.toJson<String?>(personalBookId),
      'readingCycleId': serializer.toJson<String?>(readingCycleId),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  ReadingSessionEntry copyWith({
    String? id,
    int? startedAt,
    Value<int?> endedAt = const Value.absent(),
    Value<String?> personalBookId = const Value.absent(),
    Value<String?> readingCycleId = const Value.absent(),
    int? createdAt,
    int? updatedAt,
  }) => ReadingSessionEntry(
    id: id ?? this.id,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    personalBookId: personalBookId.present
        ? personalBookId.value
        : this.personalBookId,
    readingCycleId: readingCycleId.present
        ? readingCycleId.value
        : this.readingCycleId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ReadingSessionEntry copyWithCompanion(ReadingSessionEntriesCompanion data) {
    return ReadingSessionEntry(
      id: data.id.present ? data.id.value : this.id,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      personalBookId: data.personalBookId.present
          ? data.personalBookId.value
          : this.personalBookId,
      readingCycleId: data.readingCycleId.present
          ? data.readingCycleId.value
          : this.readingCycleId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReadingSessionEntry(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('personalBookId: $personalBookId, ')
          ..write('readingCycleId: $readingCycleId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    startedAt,
    endedAt,
    personalBookId,
    readingCycleId,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadingSessionEntry &&
          other.id == this.id &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.personalBookId == this.personalBookId &&
          other.readingCycleId == this.readingCycleId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ReadingSessionEntriesCompanion
    extends UpdateCompanion<ReadingSessionEntry> {
  final Value<String> id;
  final Value<int> startedAt;
  final Value<int?> endedAt;
  final Value<String?> personalBookId;
  final Value<String?> readingCycleId;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const ReadingSessionEntriesCompanion({
    this.id = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.personalBookId = const Value.absent(),
    this.readingCycleId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReadingSessionEntriesCompanion.insert({
    required String id,
    required int startedAt,
    this.endedAt = const Value.absent(),
    this.personalBookId = const Value.absent(),
    this.readingCycleId = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       startedAt = Value(startedAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ReadingSessionEntry> custom({
    Expression<String>? id,
    Expression<int>? startedAt,
    Expression<int>? endedAt,
    Expression<String>? personalBookId,
    Expression<String>? readingCycleId,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (personalBookId != null) 'personal_book_id': personalBookId,
      if (readingCycleId != null) 'reading_cycle_id': readingCycleId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReadingSessionEntriesCompanion copyWith({
    Value<String>? id,
    Value<int>? startedAt,
    Value<int?>? endedAt,
    Value<String?>? personalBookId,
    Value<String?>? readingCycleId,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return ReadingSessionEntriesCompanion(
      id: id ?? this.id,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      personalBookId: personalBookId ?? this.personalBookId,
      readingCycleId: readingCycleId ?? this.readingCycleId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<int>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<int>(endedAt.value);
    }
    if (personalBookId.present) {
      map['personal_book_id'] = Variable<String>(personalBookId.value);
    }
    if (readingCycleId.present) {
      map['reading_cycle_id'] = Variable<String>(readingCycleId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
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
    return (StringBuffer('ReadingSessionEntriesCompanion(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('personalBookId: $personalBookId, ')
          ..write('readingCycleId: $readingCycleId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BiteEntriesTable extends BiteEntries
    with TableInfo<$BiteEntriesTable, BiteEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BiteEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceKindMeta = const VerificationMeta(
    'sourceKind',
  );
  @override
  late final GeneratedColumn<String> sourceKind = GeneratedColumn<String>(
    'source_kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _extractionStatusMeta = const VerificationMeta(
    'extractionStatus',
  );
  @override
  late final GeneratedColumn<String> extractionStatus = GeneratedColumn<String>(
    'extraction_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _extractedTextMeta = const VerificationMeta(
    'extractedText',
  );
  @override
  late final GeneratedColumn<String> extractedText = GeneratedColumn<String>(
    'extracted_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagsJsonMeta = const VerificationMeta(
    'tagsJson',
  );
  @override
  late final GeneratedColumn<String> tagsJson = GeneratedColumn<String>(
    'tags_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _readingSessionIdMeta = const VerificationMeta(
    'readingSessionId',
  );
  @override
  late final GeneratedColumn<String> readingSessionId = GeneratedColumn<String>(
    'reading_session_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES reading_sessions (id)',
    ),
  );
  static const VerificationMeta _personalBookIdMeta = const VerificationMeta(
    'personalBookId',
  );
  @override
  late final GeneratedColumn<String> personalBookId = GeneratedColumn<String>(
    'personal_book_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES personal_books (id)',
    ),
  );
  static const VerificationMeta _readingCycleIdMeta = const VerificationMeta(
    'readingCycleId',
  );
  @override
  late final GeneratedColumn<String> readingCycleId = GeneratedColumn<String>(
    'reading_cycle_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES reading_cycles (id)',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
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
    id,
    sourceKind,
    extractionStatus,
    extractedText,
    tagsJson,
    readingSessionId,
    personalBookId,
    readingCycleId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bites';
  @override
  VerificationContext validateIntegrity(
    Insertable<BiteEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('source_kind')) {
      context.handle(
        _sourceKindMeta,
        sourceKind.isAcceptableOrUnknown(data['source_kind']!, _sourceKindMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceKindMeta);
    }
    if (data.containsKey('extraction_status')) {
      context.handle(
        _extractionStatusMeta,
        extractionStatus.isAcceptableOrUnknown(
          data['extraction_status']!,
          _extractionStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_extractionStatusMeta);
    }
    if (data.containsKey('extracted_text')) {
      context.handle(
        _extractedTextMeta,
        extractedText.isAcceptableOrUnknown(
          data['extracted_text']!,
          _extractedTextMeta,
        ),
      );
    }
    if (data.containsKey('tags_json')) {
      context.handle(
        _tagsJsonMeta,
        tagsJson.isAcceptableOrUnknown(data['tags_json']!, _tagsJsonMeta),
      );
    }
    if (data.containsKey('reading_session_id')) {
      context.handle(
        _readingSessionIdMeta,
        readingSessionId.isAcceptableOrUnknown(
          data['reading_session_id']!,
          _readingSessionIdMeta,
        ),
      );
    }
    if (data.containsKey('personal_book_id')) {
      context.handle(
        _personalBookIdMeta,
        personalBookId.isAcceptableOrUnknown(
          data['personal_book_id']!,
          _personalBookIdMeta,
        ),
      );
    }
    if (data.containsKey('reading_cycle_id')) {
      context.handle(
        _readingCycleIdMeta,
        readingCycleId.isAcceptableOrUnknown(
          data['reading_cycle_id']!,
          _readingCycleIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BiteEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BiteEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sourceKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_kind'],
      )!,
      extractionStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extraction_status'],
      )!,
      extractedText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extracted_text'],
      ),
      tagsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags_json'],
      )!,
      readingSessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reading_session_id'],
      ),
      personalBookId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}personal_book_id'],
      ),
      readingCycleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reading_cycle_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BiteEntriesTable createAlias(String alias) {
    return $BiteEntriesTable(attachedDatabase, alias);
  }
}

class BiteEntry extends DataClass implements Insertable<BiteEntry> {
  final String id;
  final String sourceKind;
  final String extractionStatus;
  final String? extractedText;
  final String tagsJson;
  final String? readingSessionId;
  final String? personalBookId;
  final String? readingCycleId;
  final int createdAt;
  final int updatedAt;
  const BiteEntry({
    required this.id,
    required this.sourceKind,
    required this.extractionStatus,
    this.extractedText,
    required this.tagsJson,
    this.readingSessionId,
    this.personalBookId,
    this.readingCycleId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_kind'] = Variable<String>(sourceKind);
    map['extraction_status'] = Variable<String>(extractionStatus);
    if (!nullToAbsent || extractedText != null) {
      map['extracted_text'] = Variable<String>(extractedText);
    }
    map['tags_json'] = Variable<String>(tagsJson);
    if (!nullToAbsent || readingSessionId != null) {
      map['reading_session_id'] = Variable<String>(readingSessionId);
    }
    if (!nullToAbsent || personalBookId != null) {
      map['personal_book_id'] = Variable<String>(personalBookId);
    }
    if (!nullToAbsent || readingCycleId != null) {
      map['reading_cycle_id'] = Variable<String>(readingCycleId);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  BiteEntriesCompanion toCompanion(bool nullToAbsent) {
    return BiteEntriesCompanion(
      id: Value(id),
      sourceKind: Value(sourceKind),
      extractionStatus: Value(extractionStatus),
      extractedText: extractedText == null && nullToAbsent
          ? const Value.absent()
          : Value(extractedText),
      tagsJson: Value(tagsJson),
      readingSessionId: readingSessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(readingSessionId),
      personalBookId: personalBookId == null && nullToAbsent
          ? const Value.absent()
          : Value(personalBookId),
      readingCycleId: readingCycleId == null && nullToAbsent
          ? const Value.absent()
          : Value(readingCycleId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory BiteEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BiteEntry(
      id: serializer.fromJson<String>(json['id']),
      sourceKind: serializer.fromJson<String>(json['sourceKind']),
      extractionStatus: serializer.fromJson<String>(json['extractionStatus']),
      extractedText: serializer.fromJson<String?>(json['extractedText']),
      tagsJson: serializer.fromJson<String>(json['tagsJson']),
      readingSessionId: serializer.fromJson<String?>(json['readingSessionId']),
      personalBookId: serializer.fromJson<String?>(json['personalBookId']),
      readingCycleId: serializer.fromJson<String?>(json['readingCycleId']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sourceKind': serializer.toJson<String>(sourceKind),
      'extractionStatus': serializer.toJson<String>(extractionStatus),
      'extractedText': serializer.toJson<String?>(extractedText),
      'tagsJson': serializer.toJson<String>(tagsJson),
      'readingSessionId': serializer.toJson<String?>(readingSessionId),
      'personalBookId': serializer.toJson<String?>(personalBookId),
      'readingCycleId': serializer.toJson<String?>(readingCycleId),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  BiteEntry copyWith({
    String? id,
    String? sourceKind,
    String? extractionStatus,
    Value<String?> extractedText = const Value.absent(),
    String? tagsJson,
    Value<String?> readingSessionId = const Value.absent(),
    Value<String?> personalBookId = const Value.absent(),
    Value<String?> readingCycleId = const Value.absent(),
    int? createdAt,
    int? updatedAt,
  }) => BiteEntry(
    id: id ?? this.id,
    sourceKind: sourceKind ?? this.sourceKind,
    extractionStatus: extractionStatus ?? this.extractionStatus,
    extractedText: extractedText.present
        ? extractedText.value
        : this.extractedText,
    tagsJson: tagsJson ?? this.tagsJson,
    readingSessionId: readingSessionId.present
        ? readingSessionId.value
        : this.readingSessionId,
    personalBookId: personalBookId.present
        ? personalBookId.value
        : this.personalBookId,
    readingCycleId: readingCycleId.present
        ? readingCycleId.value
        : this.readingCycleId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  BiteEntry copyWithCompanion(BiteEntriesCompanion data) {
    return BiteEntry(
      id: data.id.present ? data.id.value : this.id,
      sourceKind: data.sourceKind.present
          ? data.sourceKind.value
          : this.sourceKind,
      extractionStatus: data.extractionStatus.present
          ? data.extractionStatus.value
          : this.extractionStatus,
      extractedText: data.extractedText.present
          ? data.extractedText.value
          : this.extractedText,
      tagsJson: data.tagsJson.present ? data.tagsJson.value : this.tagsJson,
      readingSessionId: data.readingSessionId.present
          ? data.readingSessionId.value
          : this.readingSessionId,
      personalBookId: data.personalBookId.present
          ? data.personalBookId.value
          : this.personalBookId,
      readingCycleId: data.readingCycleId.present
          ? data.readingCycleId.value
          : this.readingCycleId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BiteEntry(')
          ..write('id: $id, ')
          ..write('sourceKind: $sourceKind, ')
          ..write('extractionStatus: $extractionStatus, ')
          ..write('extractedText: $extractedText, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('readingSessionId: $readingSessionId, ')
          ..write('personalBookId: $personalBookId, ')
          ..write('readingCycleId: $readingCycleId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sourceKind,
    extractionStatus,
    extractedText,
    tagsJson,
    readingSessionId,
    personalBookId,
    readingCycleId,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BiteEntry &&
          other.id == this.id &&
          other.sourceKind == this.sourceKind &&
          other.extractionStatus == this.extractionStatus &&
          other.extractedText == this.extractedText &&
          other.tagsJson == this.tagsJson &&
          other.readingSessionId == this.readingSessionId &&
          other.personalBookId == this.personalBookId &&
          other.readingCycleId == this.readingCycleId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BiteEntriesCompanion extends UpdateCompanion<BiteEntry> {
  final Value<String> id;
  final Value<String> sourceKind;
  final Value<String> extractionStatus;
  final Value<String?> extractedText;
  final Value<String> tagsJson;
  final Value<String?> readingSessionId;
  final Value<String?> personalBookId;
  final Value<String?> readingCycleId;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const BiteEntriesCompanion({
    this.id = const Value.absent(),
    this.sourceKind = const Value.absent(),
    this.extractionStatus = const Value.absent(),
    this.extractedText = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.readingSessionId = const Value.absent(),
    this.personalBookId = const Value.absent(),
    this.readingCycleId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BiteEntriesCompanion.insert({
    required String id,
    required String sourceKind,
    required String extractionStatus,
    this.extractedText = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.readingSessionId = const Value.absent(),
    this.personalBookId = const Value.absent(),
    this.readingCycleId = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sourceKind = Value(sourceKind),
       extractionStatus = Value(extractionStatus),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<BiteEntry> custom({
    Expression<String>? id,
    Expression<String>? sourceKind,
    Expression<String>? extractionStatus,
    Expression<String>? extractedText,
    Expression<String>? tagsJson,
    Expression<String>? readingSessionId,
    Expression<String>? personalBookId,
    Expression<String>? readingCycleId,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceKind != null) 'source_kind': sourceKind,
      if (extractionStatus != null) 'extraction_status': extractionStatus,
      if (extractedText != null) 'extracted_text': extractedText,
      if (tagsJson != null) 'tags_json': tagsJson,
      if (readingSessionId != null) 'reading_session_id': readingSessionId,
      if (personalBookId != null) 'personal_book_id': personalBookId,
      if (readingCycleId != null) 'reading_cycle_id': readingCycleId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BiteEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? sourceKind,
    Value<String>? extractionStatus,
    Value<String?>? extractedText,
    Value<String>? tagsJson,
    Value<String?>? readingSessionId,
    Value<String?>? personalBookId,
    Value<String?>? readingCycleId,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return BiteEntriesCompanion(
      id: id ?? this.id,
      sourceKind: sourceKind ?? this.sourceKind,
      extractionStatus: extractionStatus ?? this.extractionStatus,
      extractedText: extractedText ?? this.extractedText,
      tagsJson: tagsJson ?? this.tagsJson,
      readingSessionId: readingSessionId ?? this.readingSessionId,
      personalBookId: personalBookId ?? this.personalBookId,
      readingCycleId: readingCycleId ?? this.readingCycleId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sourceKind.present) {
      map['source_kind'] = Variable<String>(sourceKind.value);
    }
    if (extractionStatus.present) {
      map['extraction_status'] = Variable<String>(extractionStatus.value);
    }
    if (extractedText.present) {
      map['extracted_text'] = Variable<String>(extractedText.value);
    }
    if (tagsJson.present) {
      map['tags_json'] = Variable<String>(tagsJson.value);
    }
    if (readingSessionId.present) {
      map['reading_session_id'] = Variable<String>(readingSessionId.value);
    }
    if (personalBookId.present) {
      map['personal_book_id'] = Variable<String>(personalBookId.value);
    }
    if (readingCycleId.present) {
      map['reading_cycle_id'] = Variable<String>(readingCycleId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
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
    return (StringBuffer('BiteEntriesCompanion(')
          ..write('id: $id, ')
          ..write('sourceKind: $sourceKind, ')
          ..write('extractionStatus: $extractionStatus, ')
          ..write('extractedText: $extractedText, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('readingSessionId: $readingSessionId, ')
          ..write('personalBookId: $personalBookId, ')
          ..write('readingCycleId: $readingCycleId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ManagedMediaEntriesTable extends ManagedMediaEntries
    with TableInfo<$ManagedMediaEntriesTable, ManagedMediaEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ManagedMediaEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _biteIdMeta = const VerificationMeta('biteId');
  @override
  late final GeneratedColumn<String> biteId = GeneratedColumn<String>(
    'bite_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES bites (id)',
    ),
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _referenceMeta = const VerificationMeta(
    'reference',
  );
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
    'reference',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _byteSizeMeta = const VerificationMeta(
    'byteSize',
  );
  @override
  late final GeneratedColumn<int> byteSize = GeneratedColumn<int>(
    'byte_size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    biteId,
    kind,
    reference,
    byteSize,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'managed_media';
  @override
  VerificationContext validateIntegrity(
    Insertable<ManagedMediaEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('bite_id')) {
      context.handle(
        _biteIdMeta,
        biteId.isAcceptableOrUnknown(data['bite_id']!, _biteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_biteIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('reference')) {
      context.handle(
        _referenceMeta,
        reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta),
      );
    } else if (isInserting) {
      context.missing(_referenceMeta);
    }
    if (data.containsKey('byte_size')) {
      context.handle(
        _byteSizeMeta,
        byteSize.isAcceptableOrUnknown(data['byte_size']!, _byteSizeMeta),
      );
    } else if (isInserting) {
      context.missing(_byteSizeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ManagedMediaEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ManagedMediaEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      biteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bite_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      reference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference'],
      )!,
      byteSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}byte_size'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ManagedMediaEntriesTable createAlias(String alias) {
    return $ManagedMediaEntriesTable(attachedDatabase, alias);
  }
}

class ManagedMediaEntry extends DataClass
    implements Insertable<ManagedMediaEntry> {
  final String id;
  final String biteId;
  final String kind;
  final String reference;
  final int byteSize;
  final int createdAt;
  const ManagedMediaEntry({
    required this.id,
    required this.biteId,
    required this.kind,
    required this.reference,
    required this.byteSize,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['bite_id'] = Variable<String>(biteId);
    map['kind'] = Variable<String>(kind);
    map['reference'] = Variable<String>(reference);
    map['byte_size'] = Variable<int>(byteSize);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  ManagedMediaEntriesCompanion toCompanion(bool nullToAbsent) {
    return ManagedMediaEntriesCompanion(
      id: Value(id),
      biteId: Value(biteId),
      kind: Value(kind),
      reference: Value(reference),
      byteSize: Value(byteSize),
      createdAt: Value(createdAt),
    );
  }

  factory ManagedMediaEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ManagedMediaEntry(
      id: serializer.fromJson<String>(json['id']),
      biteId: serializer.fromJson<String>(json['biteId']),
      kind: serializer.fromJson<String>(json['kind']),
      reference: serializer.fromJson<String>(json['reference']),
      byteSize: serializer.fromJson<int>(json['byteSize']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'biteId': serializer.toJson<String>(biteId),
      'kind': serializer.toJson<String>(kind),
      'reference': serializer.toJson<String>(reference),
      'byteSize': serializer.toJson<int>(byteSize),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  ManagedMediaEntry copyWith({
    String? id,
    String? biteId,
    String? kind,
    String? reference,
    int? byteSize,
    int? createdAt,
  }) => ManagedMediaEntry(
    id: id ?? this.id,
    biteId: biteId ?? this.biteId,
    kind: kind ?? this.kind,
    reference: reference ?? this.reference,
    byteSize: byteSize ?? this.byteSize,
    createdAt: createdAt ?? this.createdAt,
  );
  ManagedMediaEntry copyWithCompanion(ManagedMediaEntriesCompanion data) {
    return ManagedMediaEntry(
      id: data.id.present ? data.id.value : this.id,
      biteId: data.biteId.present ? data.biteId.value : this.biteId,
      kind: data.kind.present ? data.kind.value : this.kind,
      reference: data.reference.present ? data.reference.value : this.reference,
      byteSize: data.byteSize.present ? data.byteSize.value : this.byteSize,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ManagedMediaEntry(')
          ..write('id: $id, ')
          ..write('biteId: $biteId, ')
          ..write('kind: $kind, ')
          ..write('reference: $reference, ')
          ..write('byteSize: $byteSize, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, biteId, kind, reference, byteSize, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ManagedMediaEntry &&
          other.id == this.id &&
          other.biteId == this.biteId &&
          other.kind == this.kind &&
          other.reference == this.reference &&
          other.byteSize == this.byteSize &&
          other.createdAt == this.createdAt);
}

class ManagedMediaEntriesCompanion extends UpdateCompanion<ManagedMediaEntry> {
  final Value<String> id;
  final Value<String> biteId;
  final Value<String> kind;
  final Value<String> reference;
  final Value<int> byteSize;
  final Value<int> createdAt;
  final Value<int> rowid;
  const ManagedMediaEntriesCompanion({
    this.id = const Value.absent(),
    this.biteId = const Value.absent(),
    this.kind = const Value.absent(),
    this.reference = const Value.absent(),
    this.byteSize = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ManagedMediaEntriesCompanion.insert({
    required String id,
    required String biteId,
    required String kind,
    required String reference,
    required int byteSize,
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       biteId = Value(biteId),
       kind = Value(kind),
       reference = Value(reference),
       byteSize = Value(byteSize),
       createdAt = Value(createdAt);
  static Insertable<ManagedMediaEntry> custom({
    Expression<String>? id,
    Expression<String>? biteId,
    Expression<String>? kind,
    Expression<String>? reference,
    Expression<int>? byteSize,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (biteId != null) 'bite_id': biteId,
      if (kind != null) 'kind': kind,
      if (reference != null) 'reference': reference,
      if (byteSize != null) 'byte_size': byteSize,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ManagedMediaEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? biteId,
    Value<String>? kind,
    Value<String>? reference,
    Value<int>? byteSize,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return ManagedMediaEntriesCompanion(
      id: id ?? this.id,
      biteId: biteId ?? this.biteId,
      kind: kind ?? this.kind,
      reference: reference ?? this.reference,
      byteSize: byteSize ?? this.byteSize,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (biteId.present) {
      map['bite_id'] = Variable<String>(biteId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (byteSize.present) {
      map['byte_size'] = Variable<int>(byteSize.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ManagedMediaEntriesCompanion(')
          ..write('id: $id, ')
          ..write('biteId: $biteId, ')
          ..write('kind: $kind, ')
          ..write('reference: $reference, ')
          ..write('byteSize: $byteSize, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExtractionJobEntriesTable extends ExtractionJobEntries
    with TableInfo<$ExtractionJobEntriesTable, ExtractionJobEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExtractionJobEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _biteIdMeta = const VerificationMeta('biteId');
  @override
  late final GeneratedColumn<String> biteId = GeneratedColumn<String>(
    'bite_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES bites (id)',
    ),
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _errorCodeMeta = const VerificationMeta(
    'errorCode',
  );
  @override
  late final GeneratedColumn<String> errorCode = GeneratedColumn<String>(
    'error_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
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
    id,
    biteId,
    kind,
    status,
    attempts,
    errorCode,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'extraction_jobs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExtractionJobEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('bite_id')) {
      context.handle(
        _biteIdMeta,
        biteId.isAcceptableOrUnknown(data['bite_id']!, _biteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_biteIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('error_code')) {
      context.handle(
        _errorCodeMeta,
        errorCode.isAcceptableOrUnknown(data['error_code']!, _errorCodeMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExtractionJobEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExtractionJobEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      biteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bite_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      errorCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_code'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ExtractionJobEntriesTable createAlias(String alias) {
    return $ExtractionJobEntriesTable(attachedDatabase, alias);
  }
}

class ExtractionJobEntry extends DataClass
    implements Insertable<ExtractionJobEntry> {
  final String id;
  final String biteId;
  final String kind;
  final String status;
  final int attempts;
  final String? errorCode;
  final int createdAt;
  final int updatedAt;
  const ExtractionJobEntry({
    required this.id,
    required this.biteId,
    required this.kind,
    required this.status,
    required this.attempts,
    this.errorCode,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['bite_id'] = Variable<String>(biteId);
    map['kind'] = Variable<String>(kind);
    map['status'] = Variable<String>(status);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || errorCode != null) {
      map['error_code'] = Variable<String>(errorCode);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  ExtractionJobEntriesCompanion toCompanion(bool nullToAbsent) {
    return ExtractionJobEntriesCompanion(
      id: Value(id),
      biteId: Value(biteId),
      kind: Value(kind),
      status: Value(status),
      attempts: Value(attempts),
      errorCode: errorCode == null && nullToAbsent
          ? const Value.absent()
          : Value(errorCode),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ExtractionJobEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExtractionJobEntry(
      id: serializer.fromJson<String>(json['id']),
      biteId: serializer.fromJson<String>(json['biteId']),
      kind: serializer.fromJson<String>(json['kind']),
      status: serializer.fromJson<String>(json['status']),
      attempts: serializer.fromJson<int>(json['attempts']),
      errorCode: serializer.fromJson<String?>(json['errorCode']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'biteId': serializer.toJson<String>(biteId),
      'kind': serializer.toJson<String>(kind),
      'status': serializer.toJson<String>(status),
      'attempts': serializer.toJson<int>(attempts),
      'errorCode': serializer.toJson<String?>(errorCode),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  ExtractionJobEntry copyWith({
    String? id,
    String? biteId,
    String? kind,
    String? status,
    int? attempts,
    Value<String?> errorCode = const Value.absent(),
    int? createdAt,
    int? updatedAt,
  }) => ExtractionJobEntry(
    id: id ?? this.id,
    biteId: biteId ?? this.biteId,
    kind: kind ?? this.kind,
    status: status ?? this.status,
    attempts: attempts ?? this.attempts,
    errorCode: errorCode.present ? errorCode.value : this.errorCode,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ExtractionJobEntry copyWithCompanion(ExtractionJobEntriesCompanion data) {
    return ExtractionJobEntry(
      id: data.id.present ? data.id.value : this.id,
      biteId: data.biteId.present ? data.biteId.value : this.biteId,
      kind: data.kind.present ? data.kind.value : this.kind,
      status: data.status.present ? data.status.value : this.status,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      errorCode: data.errorCode.present ? data.errorCode.value : this.errorCode,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExtractionJobEntry(')
          ..write('id: $id, ')
          ..write('biteId: $biteId, ')
          ..write('kind: $kind, ')
          ..write('status: $status, ')
          ..write('attempts: $attempts, ')
          ..write('errorCode: $errorCode, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    biteId,
    kind,
    status,
    attempts,
    errorCode,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExtractionJobEntry &&
          other.id == this.id &&
          other.biteId == this.biteId &&
          other.kind == this.kind &&
          other.status == this.status &&
          other.attempts == this.attempts &&
          other.errorCode == this.errorCode &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ExtractionJobEntriesCompanion
    extends UpdateCompanion<ExtractionJobEntry> {
  final Value<String> id;
  final Value<String> biteId;
  final Value<String> kind;
  final Value<String> status;
  final Value<int> attempts;
  final Value<String?> errorCode;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const ExtractionJobEntriesCompanion({
    this.id = const Value.absent(),
    this.biteId = const Value.absent(),
    this.kind = const Value.absent(),
    this.status = const Value.absent(),
    this.attempts = const Value.absent(),
    this.errorCode = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExtractionJobEntriesCompanion.insert({
    required String id,
    required String biteId,
    required String kind,
    required String status,
    this.attempts = const Value.absent(),
    this.errorCode = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       biteId = Value(biteId),
       kind = Value(kind),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ExtractionJobEntry> custom({
    Expression<String>? id,
    Expression<String>? biteId,
    Expression<String>? kind,
    Expression<String>? status,
    Expression<int>? attempts,
    Expression<String>? errorCode,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (biteId != null) 'bite_id': biteId,
      if (kind != null) 'kind': kind,
      if (status != null) 'status': status,
      if (attempts != null) 'attempts': attempts,
      if (errorCode != null) 'error_code': errorCode,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExtractionJobEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? biteId,
    Value<String>? kind,
    Value<String>? status,
    Value<int>? attempts,
    Value<String?>? errorCode,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return ExtractionJobEntriesCompanion(
      id: id ?? this.id,
      biteId: biteId ?? this.biteId,
      kind: kind ?? this.kind,
      status: status ?? this.status,
      attempts: attempts ?? this.attempts,
      errorCode: errorCode ?? this.errorCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (biteId.present) {
      map['bite_id'] = Variable<String>(biteId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (errorCode.present) {
      map['error_code'] = Variable<String>(errorCode.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
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
    return (StringBuffer('ExtractionJobEntriesCompanion(')
          ..write('id: $id, ')
          ..write('biteId: $biteId, ')
          ..write('kind: $kind, ')
          ..write('status: $status, ')
          ..write('attempts: $attempts, ')
          ..write('errorCode: $errorCode, ')
          ..write('createdAt: $createdAt, ')
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
  late final $CatalogDetailCacheEntriesTable catalogDetailCacheEntries =
      $CatalogDetailCacheEntriesTable(this);
  late final $PersonalBookEntriesTable personalBookEntries =
      $PersonalBookEntriesTable(this);
  late final $ReadingCycleEntriesTable readingCycleEntries =
      $ReadingCycleEntriesTable(this);
  late final $ReadingSessionEntriesTable readingSessionEntries =
      $ReadingSessionEntriesTable(this);
  late final $BiteEntriesTable biteEntries = $BiteEntriesTable(this);
  late final $ManagedMediaEntriesTable managedMediaEntries =
      $ManagedMediaEntriesTable(this);
  late final $ExtractionJobEntriesTable extractionJobEntries =
      $ExtractionJobEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    catalogCacheEntries,
    catalogDetailCacheEntries,
    personalBookEntries,
    readingCycleEntries,
    readingSessionEntries,
    biteEntries,
    managedMediaEntries,
    extractionJobEntries,
  ];
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
typedef $$CatalogDetailCacheEntriesTableCreateCompanionBuilder =
    CatalogDetailCacheEntriesCompanion Function({
      required String cacheKey,
      required String payload,
      required int lastAccessAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$CatalogDetailCacheEntriesTableUpdateCompanionBuilder =
    CatalogDetailCacheEntriesCompanion Function({
      Value<String> cacheKey,
      Value<String> payload,
      Value<int> lastAccessAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$CatalogDetailCacheEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $CatalogDetailCacheEntriesTable> {
  $$CatalogDetailCacheEntriesTableFilterComposer({
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

class $$CatalogDetailCacheEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CatalogDetailCacheEntriesTable> {
  $$CatalogDetailCacheEntriesTableOrderingComposer({
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

class $$CatalogDetailCacheEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CatalogDetailCacheEntriesTable> {
  $$CatalogDetailCacheEntriesTableAnnotationComposer({
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

class $$CatalogDetailCacheEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CatalogDetailCacheEntriesTable,
          CatalogDetailCacheEntry,
          $$CatalogDetailCacheEntriesTableFilterComposer,
          $$CatalogDetailCacheEntriesTableOrderingComposer,
          $$CatalogDetailCacheEntriesTableAnnotationComposer,
          $$CatalogDetailCacheEntriesTableCreateCompanionBuilder,
          $$CatalogDetailCacheEntriesTableUpdateCompanionBuilder,
          (
            CatalogDetailCacheEntry,
            BaseReferences<
              _$AppDatabase,
              $CatalogDetailCacheEntriesTable,
              CatalogDetailCacheEntry
            >,
          ),
          CatalogDetailCacheEntry,
          PrefetchHooks Function()
        > {
  $$CatalogDetailCacheEntriesTableTableManager(
    _$AppDatabase db,
    $CatalogDetailCacheEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatalogDetailCacheEntriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CatalogDetailCacheEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CatalogDetailCacheEntriesTableAnnotationComposer(
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
              }) => CatalogDetailCacheEntriesCompanion(
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
              }) => CatalogDetailCacheEntriesCompanion.insert(
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

typedef $$CatalogDetailCacheEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CatalogDetailCacheEntriesTable,
      CatalogDetailCacheEntry,
      $$CatalogDetailCacheEntriesTableFilterComposer,
      $$CatalogDetailCacheEntriesTableOrderingComposer,
      $$CatalogDetailCacheEntriesTableAnnotationComposer,
      $$CatalogDetailCacheEntriesTableCreateCompanionBuilder,
      $$CatalogDetailCacheEntriesTableUpdateCompanionBuilder,
      (
        CatalogDetailCacheEntry,
        BaseReferences<
          _$AppDatabase,
          $CatalogDetailCacheEntriesTable,
          CatalogDetailCacheEntry
        >,
      ),
      CatalogDetailCacheEntry,
      PrefetchHooks Function()
    >;
typedef $$PersonalBookEntriesTableCreateCompanionBuilder =
    PersonalBookEntriesCompanion Function({
      required String id,
      required String title,
      required String authorsJson,
      required String snapshotJson,
      Value<String?> catalogProvider,
      Value<String?> catalogBookId,
      Value<String?> catalogWorkId,
      required int createdAt,
      required int updatedAt,
      Value<int?> archivedAt,
      Value<int> rowid,
    });
typedef $$PersonalBookEntriesTableUpdateCompanionBuilder =
    PersonalBookEntriesCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> authorsJson,
      Value<String> snapshotJson,
      Value<String?> catalogProvider,
      Value<String?> catalogBookId,
      Value<String?> catalogWorkId,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> archivedAt,
      Value<int> rowid,
    });

final class $$PersonalBookEntriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PersonalBookEntriesTable,
          PersonalBookEntry
        > {
  $$PersonalBookEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ReadingCycleEntriesTable, List<ReadingCycleEntry>>
  _readingCycleEntriesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.readingCycleEntries,
        aliasName: $_aliasNameGenerator(
          db.personalBookEntries.id,
          db.readingCycleEntries.personalBookId,
        ),
      );

  $$ReadingCycleEntriesTableProcessedTableManager get readingCycleEntriesRefs {
    final manager = $$ReadingCycleEntriesTableTableManager(
      $_db,
      $_db.readingCycleEntries,
    ).filter((f) => f.personalBookId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _readingCycleEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ReadingSessionEntriesTable,
    List<ReadingSessionEntry>
  >
  _readingSessionEntriesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.readingSessionEntries,
        aliasName: $_aliasNameGenerator(
          db.personalBookEntries.id,
          db.readingSessionEntries.personalBookId,
        ),
      );

  $$ReadingSessionEntriesTableProcessedTableManager
  get readingSessionEntriesRefs {
    final manager = $$ReadingSessionEntriesTableTableManager(
      $_db,
      $_db.readingSessionEntries,
    ).filter((f) => f.personalBookId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _readingSessionEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BiteEntriesTable, List<BiteEntry>>
  _biteEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.biteEntries,
    aliasName: $_aliasNameGenerator(
      db.personalBookEntries.id,
      db.biteEntries.personalBookId,
    ),
  );

  $$BiteEntriesTableProcessedTableManager get biteEntriesRefs {
    final manager = $$BiteEntriesTableTableManager(
      $_db,
      $_db.biteEntries,
    ).filter((f) => f.personalBookId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_biteEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PersonalBookEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $PersonalBookEntriesTable> {
  $$PersonalBookEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorsJson => $composableBuilder(
    column: $table.authorsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get snapshotJson => $composableBuilder(
    column: $table.snapshotJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get catalogProvider => $composableBuilder(
    column: $table.catalogProvider,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get catalogBookId => $composableBuilder(
    column: $table.catalogBookId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get catalogWorkId => $composableBuilder(
    column: $table.catalogWorkId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> readingCycleEntriesRefs(
    Expression<bool> Function($$ReadingCycleEntriesTableFilterComposer f) f,
  ) {
    final $$ReadingCycleEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readingCycleEntries,
      getReferencedColumn: (t) => t.personalBookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingCycleEntriesTableFilterComposer(
            $db: $db,
            $table: $db.readingCycleEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> readingSessionEntriesRefs(
    Expression<bool> Function($$ReadingSessionEntriesTableFilterComposer f) f,
  ) {
    final $$ReadingSessionEntriesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.readingSessionEntries,
          getReferencedColumn: (t) => t.personalBookId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ReadingSessionEntriesTableFilterComposer(
                $db: $db,
                $table: $db.readingSessionEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> biteEntriesRefs(
    Expression<bool> Function($$BiteEntriesTableFilterComposer f) f,
  ) {
    final $$BiteEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.biteEntries,
      getReferencedColumn: (t) => t.personalBookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BiteEntriesTableFilterComposer(
            $db: $db,
            $table: $db.biteEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PersonalBookEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $PersonalBookEntriesTable> {
  $$PersonalBookEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorsJson => $composableBuilder(
    column: $table.authorsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get snapshotJson => $composableBuilder(
    column: $table.snapshotJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get catalogProvider => $composableBuilder(
    column: $table.catalogProvider,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get catalogBookId => $composableBuilder(
    column: $table.catalogBookId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get catalogWorkId => $composableBuilder(
    column: $table.catalogWorkId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PersonalBookEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PersonalBookEntriesTable> {
  $$PersonalBookEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get authorsJson => $composableBuilder(
    column: $table.authorsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get snapshotJson => $composableBuilder(
    column: $table.snapshotJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get catalogProvider => $composableBuilder(
    column: $table.catalogProvider,
    builder: (column) => column,
  );

  GeneratedColumn<String> get catalogBookId => $composableBuilder(
    column: $table.catalogBookId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get catalogWorkId => $composableBuilder(
    column: $table.catalogWorkId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  Expression<T> readingCycleEntriesRefs<T extends Object>(
    Expression<T> Function($$ReadingCycleEntriesTableAnnotationComposer a) f,
  ) {
    final $$ReadingCycleEntriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.readingCycleEntries,
          getReferencedColumn: (t) => t.personalBookId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ReadingCycleEntriesTableAnnotationComposer(
                $db: $db,
                $table: $db.readingCycleEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> readingSessionEntriesRefs<T extends Object>(
    Expression<T> Function($$ReadingSessionEntriesTableAnnotationComposer a) f,
  ) {
    final $$ReadingSessionEntriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.readingSessionEntries,
          getReferencedColumn: (t) => t.personalBookId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ReadingSessionEntriesTableAnnotationComposer(
                $db: $db,
                $table: $db.readingSessionEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> biteEntriesRefs<T extends Object>(
    Expression<T> Function($$BiteEntriesTableAnnotationComposer a) f,
  ) {
    final $$BiteEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.biteEntries,
      getReferencedColumn: (t) => t.personalBookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BiteEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.biteEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PersonalBookEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PersonalBookEntriesTable,
          PersonalBookEntry,
          $$PersonalBookEntriesTableFilterComposer,
          $$PersonalBookEntriesTableOrderingComposer,
          $$PersonalBookEntriesTableAnnotationComposer,
          $$PersonalBookEntriesTableCreateCompanionBuilder,
          $$PersonalBookEntriesTableUpdateCompanionBuilder,
          (PersonalBookEntry, $$PersonalBookEntriesTableReferences),
          PersonalBookEntry,
          PrefetchHooks Function({
            bool readingCycleEntriesRefs,
            bool readingSessionEntriesRefs,
            bool biteEntriesRefs,
          })
        > {
  $$PersonalBookEntriesTableTableManager(
    _$AppDatabase db,
    $PersonalBookEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersonalBookEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PersonalBookEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PersonalBookEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> authorsJson = const Value.absent(),
                Value<String> snapshotJson = const Value.absent(),
                Value<String?> catalogProvider = const Value.absent(),
                Value<String?> catalogBookId = const Value.absent(),
                Value<String?> catalogWorkId = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PersonalBookEntriesCompanion(
                id: id,
                title: title,
                authorsJson: authorsJson,
                snapshotJson: snapshotJson,
                catalogProvider: catalogProvider,
                catalogBookId: catalogBookId,
                catalogWorkId: catalogWorkId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String authorsJson,
                required String snapshotJson,
                Value<String?> catalogProvider = const Value.absent(),
                Value<String?> catalogBookId = const Value.absent(),
                Value<String?> catalogWorkId = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PersonalBookEntriesCompanion.insert(
                id: id,
                title: title,
                authorsJson: authorsJson,
                snapshotJson: snapshotJson,
                catalogProvider: catalogProvider,
                catalogBookId: catalogBookId,
                catalogWorkId: catalogWorkId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PersonalBookEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                readingCycleEntriesRefs = false,
                readingSessionEntriesRefs = false,
                biteEntriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (readingCycleEntriesRefs) db.readingCycleEntries,
                    if (readingSessionEntriesRefs) db.readingSessionEntries,
                    if (biteEntriesRefs) db.biteEntries,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (readingCycleEntriesRefs)
                        await $_getPrefetchedData<
                          PersonalBookEntry,
                          $PersonalBookEntriesTable,
                          ReadingCycleEntry
                        >(
                          currentTable: table,
                          referencedTable: $$PersonalBookEntriesTableReferences
                              ._readingCycleEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PersonalBookEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).readingCycleEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.personalBookId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (readingSessionEntriesRefs)
                        await $_getPrefetchedData<
                          PersonalBookEntry,
                          $PersonalBookEntriesTable,
                          ReadingSessionEntry
                        >(
                          currentTable: table,
                          referencedTable: $$PersonalBookEntriesTableReferences
                              ._readingSessionEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PersonalBookEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).readingSessionEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.personalBookId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (biteEntriesRefs)
                        await $_getPrefetchedData<
                          PersonalBookEntry,
                          $PersonalBookEntriesTable,
                          BiteEntry
                        >(
                          currentTable: table,
                          referencedTable: $$PersonalBookEntriesTableReferences
                              ._biteEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PersonalBookEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).biteEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.personalBookId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PersonalBookEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PersonalBookEntriesTable,
      PersonalBookEntry,
      $$PersonalBookEntriesTableFilterComposer,
      $$PersonalBookEntriesTableOrderingComposer,
      $$PersonalBookEntriesTableAnnotationComposer,
      $$PersonalBookEntriesTableCreateCompanionBuilder,
      $$PersonalBookEntriesTableUpdateCompanionBuilder,
      (PersonalBookEntry, $$PersonalBookEntriesTableReferences),
      PersonalBookEntry,
      PrefetchHooks Function({
        bool readingCycleEntriesRefs,
        bool readingSessionEntriesRefs,
        bool biteEntriesRefs,
      })
    >;
typedef $$ReadingCycleEntriesTableCreateCompanionBuilder =
    ReadingCycleEntriesCompanion Function({
      required String id,
      required String personalBookId,
      required String status,
      required int startedAt,
      Value<int?> endedAt,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$ReadingCycleEntriesTableUpdateCompanionBuilder =
    ReadingCycleEntriesCompanion Function({
      Value<String> id,
      Value<String> personalBookId,
      Value<String> status,
      Value<int> startedAt,
      Value<int?> endedAt,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$ReadingCycleEntriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ReadingCycleEntriesTable,
          ReadingCycleEntry
        > {
  $$ReadingCycleEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PersonalBookEntriesTable _personalBookIdTable(_$AppDatabase db) =>
      db.personalBookEntries.createAlias(
        $_aliasNameGenerator(
          db.readingCycleEntries.personalBookId,
          db.personalBookEntries.id,
        ),
      );

  $$PersonalBookEntriesTableProcessedTableManager get personalBookId {
    final $_column = $_itemColumn<String>('personal_book_id')!;

    final manager = $$PersonalBookEntriesTableTableManager(
      $_db,
      $_db.personalBookEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_personalBookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $ReadingSessionEntriesTable,
    List<ReadingSessionEntry>
  >
  _readingSessionEntriesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.readingSessionEntries,
        aliasName: $_aliasNameGenerator(
          db.readingCycleEntries.id,
          db.readingSessionEntries.readingCycleId,
        ),
      );

  $$ReadingSessionEntriesTableProcessedTableManager
  get readingSessionEntriesRefs {
    final manager = $$ReadingSessionEntriesTableTableManager(
      $_db,
      $_db.readingSessionEntries,
    ).filter((f) => f.readingCycleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _readingSessionEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BiteEntriesTable, List<BiteEntry>>
  _biteEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.biteEntries,
    aliasName: $_aliasNameGenerator(
      db.readingCycleEntries.id,
      db.biteEntries.readingCycleId,
    ),
  );

  $$BiteEntriesTableProcessedTableManager get biteEntriesRefs {
    final manager = $$BiteEntriesTableTableManager(
      $_db,
      $_db.biteEntries,
    ).filter((f) => f.readingCycleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_biteEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ReadingCycleEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $ReadingCycleEntriesTable> {
  $$ReadingCycleEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PersonalBookEntriesTableFilterComposer get personalBookId {
    final $$PersonalBookEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personalBookId,
      referencedTable: $db.personalBookEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonalBookEntriesTableFilterComposer(
            $db: $db,
            $table: $db.personalBookEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> readingSessionEntriesRefs(
    Expression<bool> Function($$ReadingSessionEntriesTableFilterComposer f) f,
  ) {
    final $$ReadingSessionEntriesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.readingSessionEntries,
          getReferencedColumn: (t) => t.readingCycleId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ReadingSessionEntriesTableFilterComposer(
                $db: $db,
                $table: $db.readingSessionEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> biteEntriesRefs(
    Expression<bool> Function($$BiteEntriesTableFilterComposer f) f,
  ) {
    final $$BiteEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.biteEntries,
      getReferencedColumn: (t) => t.readingCycleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BiteEntriesTableFilterComposer(
            $db: $db,
            $table: $db.biteEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ReadingCycleEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ReadingCycleEntriesTable> {
  $$ReadingCycleEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PersonalBookEntriesTableOrderingComposer get personalBookId {
    final $$PersonalBookEntriesTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.personalBookId,
          referencedTable: $db.personalBookEntries,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PersonalBookEntriesTableOrderingComposer(
                $db: $db,
                $table: $db.personalBookEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ReadingCycleEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReadingCycleEntriesTable> {
  $$ReadingCycleEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<int> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$PersonalBookEntriesTableAnnotationComposer get personalBookId {
    final $$PersonalBookEntriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.personalBookId,
          referencedTable: $db.personalBookEntries,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PersonalBookEntriesTableAnnotationComposer(
                $db: $db,
                $table: $db.personalBookEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> readingSessionEntriesRefs<T extends Object>(
    Expression<T> Function($$ReadingSessionEntriesTableAnnotationComposer a) f,
  ) {
    final $$ReadingSessionEntriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.readingSessionEntries,
          getReferencedColumn: (t) => t.readingCycleId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ReadingSessionEntriesTableAnnotationComposer(
                $db: $db,
                $table: $db.readingSessionEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> biteEntriesRefs<T extends Object>(
    Expression<T> Function($$BiteEntriesTableAnnotationComposer a) f,
  ) {
    final $$BiteEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.biteEntries,
      getReferencedColumn: (t) => t.readingCycleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BiteEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.biteEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ReadingCycleEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReadingCycleEntriesTable,
          ReadingCycleEntry,
          $$ReadingCycleEntriesTableFilterComposer,
          $$ReadingCycleEntriesTableOrderingComposer,
          $$ReadingCycleEntriesTableAnnotationComposer,
          $$ReadingCycleEntriesTableCreateCompanionBuilder,
          $$ReadingCycleEntriesTableUpdateCompanionBuilder,
          (ReadingCycleEntry, $$ReadingCycleEntriesTableReferences),
          ReadingCycleEntry,
          PrefetchHooks Function({
            bool personalBookId,
            bool readingSessionEntriesRefs,
            bool biteEntriesRefs,
          })
        > {
  $$ReadingCycleEntriesTableTableManager(
    _$AppDatabase db,
    $ReadingCycleEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReadingCycleEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReadingCycleEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ReadingCycleEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> personalBookId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> startedAt = const Value.absent(),
                Value<int?> endedAt = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReadingCycleEntriesCompanion(
                id: id,
                personalBookId: personalBookId,
                status: status,
                startedAt: startedAt,
                endedAt: endedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String personalBookId,
                required String status,
                required int startedAt,
                Value<int?> endedAt = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ReadingCycleEntriesCompanion.insert(
                id: id,
                personalBookId: personalBookId,
                status: status,
                startedAt: startedAt,
                endedAt: endedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ReadingCycleEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                personalBookId = false,
                readingSessionEntriesRefs = false,
                biteEntriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (readingSessionEntriesRefs) db.readingSessionEntries,
                    if (biteEntriesRefs) db.biteEntries,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (personalBookId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.personalBookId,
                                    referencedTable:
                                        $$ReadingCycleEntriesTableReferences
                                            ._personalBookIdTable(db),
                                    referencedColumn:
                                        $$ReadingCycleEntriesTableReferences
                                            ._personalBookIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (readingSessionEntriesRefs)
                        await $_getPrefetchedData<
                          ReadingCycleEntry,
                          $ReadingCycleEntriesTable,
                          ReadingSessionEntry
                        >(
                          currentTable: table,
                          referencedTable: $$ReadingCycleEntriesTableReferences
                              ._readingSessionEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ReadingCycleEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).readingSessionEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.readingCycleId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (biteEntriesRefs)
                        await $_getPrefetchedData<
                          ReadingCycleEntry,
                          $ReadingCycleEntriesTable,
                          BiteEntry
                        >(
                          currentTable: table,
                          referencedTable: $$ReadingCycleEntriesTableReferences
                              ._biteEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ReadingCycleEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).biteEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.readingCycleId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ReadingCycleEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReadingCycleEntriesTable,
      ReadingCycleEntry,
      $$ReadingCycleEntriesTableFilterComposer,
      $$ReadingCycleEntriesTableOrderingComposer,
      $$ReadingCycleEntriesTableAnnotationComposer,
      $$ReadingCycleEntriesTableCreateCompanionBuilder,
      $$ReadingCycleEntriesTableUpdateCompanionBuilder,
      (ReadingCycleEntry, $$ReadingCycleEntriesTableReferences),
      ReadingCycleEntry,
      PrefetchHooks Function({
        bool personalBookId,
        bool readingSessionEntriesRefs,
        bool biteEntriesRefs,
      })
    >;
typedef $$ReadingSessionEntriesTableCreateCompanionBuilder =
    ReadingSessionEntriesCompanion Function({
      required String id,
      required int startedAt,
      Value<int?> endedAt,
      Value<String?> personalBookId,
      Value<String?> readingCycleId,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$ReadingSessionEntriesTableUpdateCompanionBuilder =
    ReadingSessionEntriesCompanion Function({
      Value<String> id,
      Value<int> startedAt,
      Value<int?> endedAt,
      Value<String?> personalBookId,
      Value<String?> readingCycleId,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$ReadingSessionEntriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ReadingSessionEntriesTable,
          ReadingSessionEntry
        > {
  $$ReadingSessionEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PersonalBookEntriesTable _personalBookIdTable(_$AppDatabase db) =>
      db.personalBookEntries.createAlias(
        $_aliasNameGenerator(
          db.readingSessionEntries.personalBookId,
          db.personalBookEntries.id,
        ),
      );

  $$PersonalBookEntriesTableProcessedTableManager? get personalBookId {
    final $_column = $_itemColumn<String>('personal_book_id');
    if ($_column == null) return null;
    final manager = $$PersonalBookEntriesTableTableManager(
      $_db,
      $_db.personalBookEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_personalBookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ReadingCycleEntriesTable _readingCycleIdTable(_$AppDatabase db) =>
      db.readingCycleEntries.createAlias(
        $_aliasNameGenerator(
          db.readingSessionEntries.readingCycleId,
          db.readingCycleEntries.id,
        ),
      );

  $$ReadingCycleEntriesTableProcessedTableManager? get readingCycleId {
    final $_column = $_itemColumn<String>('reading_cycle_id');
    if ($_column == null) return null;
    final manager = $$ReadingCycleEntriesTableTableManager(
      $_db,
      $_db.readingCycleEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_readingCycleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$BiteEntriesTable, List<BiteEntry>>
  _biteEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.biteEntries,
    aliasName: $_aliasNameGenerator(
      db.readingSessionEntries.id,
      db.biteEntries.readingSessionId,
    ),
  );

  $$BiteEntriesTableProcessedTableManager get biteEntriesRefs {
    final manager = $$BiteEntriesTableTableManager($_db, $_db.biteEntries)
        .filter(
          (f) => f.readingSessionId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_biteEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ReadingSessionEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $ReadingSessionEntriesTable> {
  $$ReadingSessionEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PersonalBookEntriesTableFilterComposer get personalBookId {
    final $$PersonalBookEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personalBookId,
      referencedTable: $db.personalBookEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonalBookEntriesTableFilterComposer(
            $db: $db,
            $table: $db.personalBookEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ReadingCycleEntriesTableFilterComposer get readingCycleId {
    final $$ReadingCycleEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.readingCycleId,
      referencedTable: $db.readingCycleEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingCycleEntriesTableFilterComposer(
            $db: $db,
            $table: $db.readingCycleEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> biteEntriesRefs(
    Expression<bool> Function($$BiteEntriesTableFilterComposer f) f,
  ) {
    final $$BiteEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.biteEntries,
      getReferencedColumn: (t) => t.readingSessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BiteEntriesTableFilterComposer(
            $db: $db,
            $table: $db.biteEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ReadingSessionEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ReadingSessionEntriesTable> {
  $$ReadingSessionEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PersonalBookEntriesTableOrderingComposer get personalBookId {
    final $$PersonalBookEntriesTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.personalBookId,
          referencedTable: $db.personalBookEntries,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PersonalBookEntriesTableOrderingComposer(
                $db: $db,
                $table: $db.personalBookEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$ReadingCycleEntriesTableOrderingComposer get readingCycleId {
    final $$ReadingCycleEntriesTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.readingCycleId,
          referencedTable: $db.readingCycleEntries,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ReadingCycleEntriesTableOrderingComposer(
                $db: $db,
                $table: $db.readingCycleEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ReadingSessionEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReadingSessionEntriesTable> {
  $$ReadingSessionEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<int> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$PersonalBookEntriesTableAnnotationComposer get personalBookId {
    final $$PersonalBookEntriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.personalBookId,
          referencedTable: $db.personalBookEntries,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PersonalBookEntriesTableAnnotationComposer(
                $db: $db,
                $table: $db.personalBookEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$ReadingCycleEntriesTableAnnotationComposer get readingCycleId {
    final $$ReadingCycleEntriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.readingCycleId,
          referencedTable: $db.readingCycleEntries,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ReadingCycleEntriesTableAnnotationComposer(
                $db: $db,
                $table: $db.readingCycleEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> biteEntriesRefs<T extends Object>(
    Expression<T> Function($$BiteEntriesTableAnnotationComposer a) f,
  ) {
    final $$BiteEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.biteEntries,
      getReferencedColumn: (t) => t.readingSessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BiteEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.biteEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ReadingSessionEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReadingSessionEntriesTable,
          ReadingSessionEntry,
          $$ReadingSessionEntriesTableFilterComposer,
          $$ReadingSessionEntriesTableOrderingComposer,
          $$ReadingSessionEntriesTableAnnotationComposer,
          $$ReadingSessionEntriesTableCreateCompanionBuilder,
          $$ReadingSessionEntriesTableUpdateCompanionBuilder,
          (ReadingSessionEntry, $$ReadingSessionEntriesTableReferences),
          ReadingSessionEntry,
          PrefetchHooks Function({
            bool personalBookId,
            bool readingCycleId,
            bool biteEntriesRefs,
          })
        > {
  $$ReadingSessionEntriesTableTableManager(
    _$AppDatabase db,
    $ReadingSessionEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReadingSessionEntriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ReadingSessionEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ReadingSessionEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> startedAt = const Value.absent(),
                Value<int?> endedAt = const Value.absent(),
                Value<String?> personalBookId = const Value.absent(),
                Value<String?> readingCycleId = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReadingSessionEntriesCompanion(
                id: id,
                startedAt: startedAt,
                endedAt: endedAt,
                personalBookId: personalBookId,
                readingCycleId: readingCycleId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int startedAt,
                Value<int?> endedAt = const Value.absent(),
                Value<String?> personalBookId = const Value.absent(),
                Value<String?> readingCycleId = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ReadingSessionEntriesCompanion.insert(
                id: id,
                startedAt: startedAt,
                endedAt: endedAt,
                personalBookId: personalBookId,
                readingCycleId: readingCycleId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ReadingSessionEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                personalBookId = false,
                readingCycleId = false,
                biteEntriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (biteEntriesRefs) db.biteEntries,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (personalBookId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.personalBookId,
                                    referencedTable:
                                        $$ReadingSessionEntriesTableReferences
                                            ._personalBookIdTable(db),
                                    referencedColumn:
                                        $$ReadingSessionEntriesTableReferences
                                            ._personalBookIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (readingCycleId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.readingCycleId,
                                    referencedTable:
                                        $$ReadingSessionEntriesTableReferences
                                            ._readingCycleIdTable(db),
                                    referencedColumn:
                                        $$ReadingSessionEntriesTableReferences
                                            ._readingCycleIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (biteEntriesRefs)
                        await $_getPrefetchedData<
                          ReadingSessionEntry,
                          $ReadingSessionEntriesTable,
                          BiteEntry
                        >(
                          currentTable: table,
                          referencedTable:
                              $$ReadingSessionEntriesTableReferences
                                  ._biteEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ReadingSessionEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).biteEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.readingSessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ReadingSessionEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReadingSessionEntriesTable,
      ReadingSessionEntry,
      $$ReadingSessionEntriesTableFilterComposer,
      $$ReadingSessionEntriesTableOrderingComposer,
      $$ReadingSessionEntriesTableAnnotationComposer,
      $$ReadingSessionEntriesTableCreateCompanionBuilder,
      $$ReadingSessionEntriesTableUpdateCompanionBuilder,
      (ReadingSessionEntry, $$ReadingSessionEntriesTableReferences),
      ReadingSessionEntry,
      PrefetchHooks Function({
        bool personalBookId,
        bool readingCycleId,
        bool biteEntriesRefs,
      })
    >;
typedef $$BiteEntriesTableCreateCompanionBuilder =
    BiteEntriesCompanion Function({
      required String id,
      required String sourceKind,
      required String extractionStatus,
      Value<String?> extractedText,
      Value<String> tagsJson,
      Value<String?> readingSessionId,
      Value<String?> personalBookId,
      Value<String?> readingCycleId,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$BiteEntriesTableUpdateCompanionBuilder =
    BiteEntriesCompanion Function({
      Value<String> id,
      Value<String> sourceKind,
      Value<String> extractionStatus,
      Value<String?> extractedText,
      Value<String> tagsJson,
      Value<String?> readingSessionId,
      Value<String?> personalBookId,
      Value<String?> readingCycleId,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$BiteEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $BiteEntriesTable, BiteEntry> {
  $$BiteEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ReadingSessionEntriesTable _readingSessionIdTable(_$AppDatabase db) =>
      db.readingSessionEntries.createAlias(
        $_aliasNameGenerator(
          db.biteEntries.readingSessionId,
          db.readingSessionEntries.id,
        ),
      );

  $$ReadingSessionEntriesTableProcessedTableManager? get readingSessionId {
    final $_column = $_itemColumn<String>('reading_session_id');
    if ($_column == null) return null;
    final manager = $$ReadingSessionEntriesTableTableManager(
      $_db,
      $_db.readingSessionEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_readingSessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PersonalBookEntriesTable _personalBookIdTable(_$AppDatabase db) =>
      db.personalBookEntries.createAlias(
        $_aliasNameGenerator(
          db.biteEntries.personalBookId,
          db.personalBookEntries.id,
        ),
      );

  $$PersonalBookEntriesTableProcessedTableManager? get personalBookId {
    final $_column = $_itemColumn<String>('personal_book_id');
    if ($_column == null) return null;
    final manager = $$PersonalBookEntriesTableTableManager(
      $_db,
      $_db.personalBookEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_personalBookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ReadingCycleEntriesTable _readingCycleIdTable(_$AppDatabase db) =>
      db.readingCycleEntries.createAlias(
        $_aliasNameGenerator(
          db.biteEntries.readingCycleId,
          db.readingCycleEntries.id,
        ),
      );

  $$ReadingCycleEntriesTableProcessedTableManager? get readingCycleId {
    final $_column = $_itemColumn<String>('reading_cycle_id');
    if ($_column == null) return null;
    final manager = $$ReadingCycleEntriesTableTableManager(
      $_db,
      $_db.readingCycleEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_readingCycleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ManagedMediaEntriesTable, List<ManagedMediaEntry>>
  _managedMediaEntriesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.managedMediaEntries,
        aliasName: $_aliasNameGenerator(
          db.biteEntries.id,
          db.managedMediaEntries.biteId,
        ),
      );

  $$ManagedMediaEntriesTableProcessedTableManager get managedMediaEntriesRefs {
    final manager = $$ManagedMediaEntriesTableTableManager(
      $_db,
      $_db.managedMediaEntries,
    ).filter((f) => f.biteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _managedMediaEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ExtractionJobEntriesTable,
    List<ExtractionJobEntry>
  >
  _extractionJobEntriesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.extractionJobEntries,
        aliasName: $_aliasNameGenerator(
          db.biteEntries.id,
          db.extractionJobEntries.biteId,
        ),
      );

  $$ExtractionJobEntriesTableProcessedTableManager
  get extractionJobEntriesRefs {
    final manager = $$ExtractionJobEntriesTableTableManager(
      $_db,
      $_db.extractionJobEntries,
    ).filter((f) => f.biteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _extractionJobEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BiteEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $BiteEntriesTable> {
  $$BiteEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceKind => $composableBuilder(
    column: $table.sourceKind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extractionStatus => $composableBuilder(
    column: $table.extractionStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extractedText => $composableBuilder(
    column: $table.extractedText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ReadingSessionEntriesTableFilterComposer get readingSessionId {
    final $$ReadingSessionEntriesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.readingSessionId,
          referencedTable: $db.readingSessionEntries,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ReadingSessionEntriesTableFilterComposer(
                $db: $db,
                $table: $db.readingSessionEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$PersonalBookEntriesTableFilterComposer get personalBookId {
    final $$PersonalBookEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personalBookId,
      referencedTable: $db.personalBookEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonalBookEntriesTableFilterComposer(
            $db: $db,
            $table: $db.personalBookEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ReadingCycleEntriesTableFilterComposer get readingCycleId {
    final $$ReadingCycleEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.readingCycleId,
      referencedTable: $db.readingCycleEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingCycleEntriesTableFilterComposer(
            $db: $db,
            $table: $db.readingCycleEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> managedMediaEntriesRefs(
    Expression<bool> Function($$ManagedMediaEntriesTableFilterComposer f) f,
  ) {
    final $$ManagedMediaEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.managedMediaEntries,
      getReferencedColumn: (t) => t.biteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ManagedMediaEntriesTableFilterComposer(
            $db: $db,
            $table: $db.managedMediaEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> extractionJobEntriesRefs(
    Expression<bool> Function($$ExtractionJobEntriesTableFilterComposer f) f,
  ) {
    final $$ExtractionJobEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.extractionJobEntries,
      getReferencedColumn: (t) => t.biteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExtractionJobEntriesTableFilterComposer(
            $db: $db,
            $table: $db.extractionJobEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BiteEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $BiteEntriesTable> {
  $$BiteEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceKind => $composableBuilder(
    column: $table.sourceKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extractionStatus => $composableBuilder(
    column: $table.extractionStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extractedText => $composableBuilder(
    column: $table.extractedText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ReadingSessionEntriesTableOrderingComposer get readingSessionId {
    final $$ReadingSessionEntriesTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.readingSessionId,
          referencedTable: $db.readingSessionEntries,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ReadingSessionEntriesTableOrderingComposer(
                $db: $db,
                $table: $db.readingSessionEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$PersonalBookEntriesTableOrderingComposer get personalBookId {
    final $$PersonalBookEntriesTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.personalBookId,
          referencedTable: $db.personalBookEntries,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PersonalBookEntriesTableOrderingComposer(
                $db: $db,
                $table: $db.personalBookEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$ReadingCycleEntriesTableOrderingComposer get readingCycleId {
    final $$ReadingCycleEntriesTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.readingCycleId,
          referencedTable: $db.readingCycleEntries,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ReadingCycleEntriesTableOrderingComposer(
                $db: $db,
                $table: $db.readingCycleEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$BiteEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BiteEntriesTable> {
  $$BiteEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceKind => $composableBuilder(
    column: $table.sourceKind,
    builder: (column) => column,
  );

  GeneratedColumn<String> get extractionStatus => $composableBuilder(
    column: $table.extractionStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get extractedText => $composableBuilder(
    column: $table.extractedText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tagsJson =>
      $composableBuilder(column: $table.tagsJson, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ReadingSessionEntriesTableAnnotationComposer get readingSessionId {
    final $$ReadingSessionEntriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.readingSessionId,
          referencedTable: $db.readingSessionEntries,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ReadingSessionEntriesTableAnnotationComposer(
                $db: $db,
                $table: $db.readingSessionEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$PersonalBookEntriesTableAnnotationComposer get personalBookId {
    final $$PersonalBookEntriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.personalBookId,
          referencedTable: $db.personalBookEntries,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PersonalBookEntriesTableAnnotationComposer(
                $db: $db,
                $table: $db.personalBookEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$ReadingCycleEntriesTableAnnotationComposer get readingCycleId {
    final $$ReadingCycleEntriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.readingCycleId,
          referencedTable: $db.readingCycleEntries,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ReadingCycleEntriesTableAnnotationComposer(
                $db: $db,
                $table: $db.readingCycleEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> managedMediaEntriesRefs<T extends Object>(
    Expression<T> Function($$ManagedMediaEntriesTableAnnotationComposer a) f,
  ) {
    final $$ManagedMediaEntriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.managedMediaEntries,
          getReferencedColumn: (t) => t.biteId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ManagedMediaEntriesTableAnnotationComposer(
                $db: $db,
                $table: $db.managedMediaEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> extractionJobEntriesRefs<T extends Object>(
    Expression<T> Function($$ExtractionJobEntriesTableAnnotationComposer a) f,
  ) {
    final $$ExtractionJobEntriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.extractionJobEntries,
          getReferencedColumn: (t) => t.biteId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ExtractionJobEntriesTableAnnotationComposer(
                $db: $db,
                $table: $db.extractionJobEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$BiteEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BiteEntriesTable,
          BiteEntry,
          $$BiteEntriesTableFilterComposer,
          $$BiteEntriesTableOrderingComposer,
          $$BiteEntriesTableAnnotationComposer,
          $$BiteEntriesTableCreateCompanionBuilder,
          $$BiteEntriesTableUpdateCompanionBuilder,
          (BiteEntry, $$BiteEntriesTableReferences),
          BiteEntry,
          PrefetchHooks Function({
            bool readingSessionId,
            bool personalBookId,
            bool readingCycleId,
            bool managedMediaEntriesRefs,
            bool extractionJobEntriesRefs,
          })
        > {
  $$BiteEntriesTableTableManager(_$AppDatabase db, $BiteEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BiteEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BiteEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BiteEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sourceKind = const Value.absent(),
                Value<String> extractionStatus = const Value.absent(),
                Value<String?> extractedText = const Value.absent(),
                Value<String> tagsJson = const Value.absent(),
                Value<String?> readingSessionId = const Value.absent(),
                Value<String?> personalBookId = const Value.absent(),
                Value<String?> readingCycleId = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BiteEntriesCompanion(
                id: id,
                sourceKind: sourceKind,
                extractionStatus: extractionStatus,
                extractedText: extractedText,
                tagsJson: tagsJson,
                readingSessionId: readingSessionId,
                personalBookId: personalBookId,
                readingCycleId: readingCycleId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sourceKind,
                required String extractionStatus,
                Value<String?> extractedText = const Value.absent(),
                Value<String> tagsJson = const Value.absent(),
                Value<String?> readingSessionId = const Value.absent(),
                Value<String?> personalBookId = const Value.absent(),
                Value<String?> readingCycleId = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => BiteEntriesCompanion.insert(
                id: id,
                sourceKind: sourceKind,
                extractionStatus: extractionStatus,
                extractedText: extractedText,
                tagsJson: tagsJson,
                readingSessionId: readingSessionId,
                personalBookId: personalBookId,
                readingCycleId: readingCycleId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BiteEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                readingSessionId = false,
                personalBookId = false,
                readingCycleId = false,
                managedMediaEntriesRefs = false,
                extractionJobEntriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (managedMediaEntriesRefs) db.managedMediaEntries,
                    if (extractionJobEntriesRefs) db.extractionJobEntries,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (readingSessionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.readingSessionId,
                                    referencedTable:
                                        $$BiteEntriesTableReferences
                                            ._readingSessionIdTable(db),
                                    referencedColumn:
                                        $$BiteEntriesTableReferences
                                            ._readingSessionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (personalBookId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.personalBookId,
                                    referencedTable:
                                        $$BiteEntriesTableReferences
                                            ._personalBookIdTable(db),
                                    referencedColumn:
                                        $$BiteEntriesTableReferences
                                            ._personalBookIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (readingCycleId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.readingCycleId,
                                    referencedTable:
                                        $$BiteEntriesTableReferences
                                            ._readingCycleIdTable(db),
                                    referencedColumn:
                                        $$BiteEntriesTableReferences
                                            ._readingCycleIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (managedMediaEntriesRefs)
                        await $_getPrefetchedData<
                          BiteEntry,
                          $BiteEntriesTable,
                          ManagedMediaEntry
                        >(
                          currentTable: table,
                          referencedTable: $$BiteEntriesTableReferences
                              ._managedMediaEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BiteEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).managedMediaEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.biteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (extractionJobEntriesRefs)
                        await $_getPrefetchedData<
                          BiteEntry,
                          $BiteEntriesTable,
                          ExtractionJobEntry
                        >(
                          currentTable: table,
                          referencedTable: $$BiteEntriesTableReferences
                              ._extractionJobEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BiteEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).extractionJobEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.biteId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$BiteEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BiteEntriesTable,
      BiteEntry,
      $$BiteEntriesTableFilterComposer,
      $$BiteEntriesTableOrderingComposer,
      $$BiteEntriesTableAnnotationComposer,
      $$BiteEntriesTableCreateCompanionBuilder,
      $$BiteEntriesTableUpdateCompanionBuilder,
      (BiteEntry, $$BiteEntriesTableReferences),
      BiteEntry,
      PrefetchHooks Function({
        bool readingSessionId,
        bool personalBookId,
        bool readingCycleId,
        bool managedMediaEntriesRefs,
        bool extractionJobEntriesRefs,
      })
    >;
typedef $$ManagedMediaEntriesTableCreateCompanionBuilder =
    ManagedMediaEntriesCompanion Function({
      required String id,
      required String biteId,
      required String kind,
      required String reference,
      required int byteSize,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$ManagedMediaEntriesTableUpdateCompanionBuilder =
    ManagedMediaEntriesCompanion Function({
      Value<String> id,
      Value<String> biteId,
      Value<String> kind,
      Value<String> reference,
      Value<int> byteSize,
      Value<int> createdAt,
      Value<int> rowid,
    });

final class $$ManagedMediaEntriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ManagedMediaEntriesTable,
          ManagedMediaEntry
        > {
  $$ManagedMediaEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BiteEntriesTable _biteIdTable(_$AppDatabase db) =>
      db.biteEntries.createAlias(
        $_aliasNameGenerator(db.managedMediaEntries.biteId, db.biteEntries.id),
      );

  $$BiteEntriesTableProcessedTableManager get biteId {
    final $_column = $_itemColumn<String>('bite_id')!;

    final manager = $$BiteEntriesTableTableManager(
      $_db,
      $_db.biteEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_biteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ManagedMediaEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $ManagedMediaEntriesTable> {
  $$ManagedMediaEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get byteSize => $composableBuilder(
    column: $table.byteSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$BiteEntriesTableFilterComposer get biteId {
    final $$BiteEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.biteId,
      referencedTable: $db.biteEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BiteEntriesTableFilterComposer(
            $db: $db,
            $table: $db.biteEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ManagedMediaEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ManagedMediaEntriesTable> {
  $$ManagedMediaEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get byteSize => $composableBuilder(
    column: $table.byteSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$BiteEntriesTableOrderingComposer get biteId {
    final $$BiteEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.biteId,
      referencedTable: $db.biteEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BiteEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.biteEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ManagedMediaEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ManagedMediaEntriesTable> {
  $$ManagedMediaEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<int> get byteSize =>
      $composableBuilder(column: $table.byteSize, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$BiteEntriesTableAnnotationComposer get biteId {
    final $$BiteEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.biteId,
      referencedTable: $db.biteEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BiteEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.biteEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ManagedMediaEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ManagedMediaEntriesTable,
          ManagedMediaEntry,
          $$ManagedMediaEntriesTableFilterComposer,
          $$ManagedMediaEntriesTableOrderingComposer,
          $$ManagedMediaEntriesTableAnnotationComposer,
          $$ManagedMediaEntriesTableCreateCompanionBuilder,
          $$ManagedMediaEntriesTableUpdateCompanionBuilder,
          (ManagedMediaEntry, $$ManagedMediaEntriesTableReferences),
          ManagedMediaEntry,
          PrefetchHooks Function({bool biteId})
        > {
  $$ManagedMediaEntriesTableTableManager(
    _$AppDatabase db,
    $ManagedMediaEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ManagedMediaEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ManagedMediaEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ManagedMediaEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> biteId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> reference = const Value.absent(),
                Value<int> byteSize = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ManagedMediaEntriesCompanion(
                id: id,
                biteId: biteId,
                kind: kind,
                reference: reference,
                byteSize: byteSize,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String biteId,
                required String kind,
                required String reference,
                required int byteSize,
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ManagedMediaEntriesCompanion.insert(
                id: id,
                biteId: biteId,
                kind: kind,
                reference: reference,
                byteSize: byteSize,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ManagedMediaEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({biteId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (biteId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.biteId,
                                referencedTable:
                                    $$ManagedMediaEntriesTableReferences
                                        ._biteIdTable(db),
                                referencedColumn:
                                    $$ManagedMediaEntriesTableReferences
                                        ._biteIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ManagedMediaEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ManagedMediaEntriesTable,
      ManagedMediaEntry,
      $$ManagedMediaEntriesTableFilterComposer,
      $$ManagedMediaEntriesTableOrderingComposer,
      $$ManagedMediaEntriesTableAnnotationComposer,
      $$ManagedMediaEntriesTableCreateCompanionBuilder,
      $$ManagedMediaEntriesTableUpdateCompanionBuilder,
      (ManagedMediaEntry, $$ManagedMediaEntriesTableReferences),
      ManagedMediaEntry,
      PrefetchHooks Function({bool biteId})
    >;
typedef $$ExtractionJobEntriesTableCreateCompanionBuilder =
    ExtractionJobEntriesCompanion Function({
      required String id,
      required String biteId,
      required String kind,
      required String status,
      Value<int> attempts,
      Value<String?> errorCode,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$ExtractionJobEntriesTableUpdateCompanionBuilder =
    ExtractionJobEntriesCompanion Function({
      Value<String> id,
      Value<String> biteId,
      Value<String> kind,
      Value<String> status,
      Value<int> attempts,
      Value<String?> errorCode,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$ExtractionJobEntriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ExtractionJobEntriesTable,
          ExtractionJobEntry
        > {
  $$ExtractionJobEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BiteEntriesTable _biteIdTable(_$AppDatabase db) =>
      db.biteEntries.createAlias(
        $_aliasNameGenerator(db.extractionJobEntries.biteId, db.biteEntries.id),
      );

  $$BiteEntriesTableProcessedTableManager get biteId {
    final $_column = $_itemColumn<String>('bite_id')!;

    final manager = $$BiteEntriesTableTableManager(
      $_db,
      $_db.biteEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_biteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExtractionJobEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $ExtractionJobEntriesTable> {
  $$ExtractionJobEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorCode => $composableBuilder(
    column: $table.errorCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$BiteEntriesTableFilterComposer get biteId {
    final $$BiteEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.biteId,
      referencedTable: $db.biteEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BiteEntriesTableFilterComposer(
            $db: $db,
            $table: $db.biteEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExtractionJobEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExtractionJobEntriesTable> {
  $$ExtractionJobEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorCode => $composableBuilder(
    column: $table.errorCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$BiteEntriesTableOrderingComposer get biteId {
    final $$BiteEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.biteId,
      referencedTable: $db.biteEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BiteEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.biteEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExtractionJobEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExtractionJobEntriesTable> {
  $$ExtractionJobEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<String> get errorCode =>
      $composableBuilder(column: $table.errorCode, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$BiteEntriesTableAnnotationComposer get biteId {
    final $$BiteEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.biteId,
      referencedTable: $db.biteEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BiteEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.biteEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExtractionJobEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExtractionJobEntriesTable,
          ExtractionJobEntry,
          $$ExtractionJobEntriesTableFilterComposer,
          $$ExtractionJobEntriesTableOrderingComposer,
          $$ExtractionJobEntriesTableAnnotationComposer,
          $$ExtractionJobEntriesTableCreateCompanionBuilder,
          $$ExtractionJobEntriesTableUpdateCompanionBuilder,
          (ExtractionJobEntry, $$ExtractionJobEntriesTableReferences),
          ExtractionJobEntry,
          PrefetchHooks Function({bool biteId})
        > {
  $$ExtractionJobEntriesTableTableManager(
    _$AppDatabase db,
    $ExtractionJobEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExtractionJobEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExtractionJobEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ExtractionJobEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> biteId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> errorCode = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExtractionJobEntriesCompanion(
                id: id,
                biteId: biteId,
                kind: kind,
                status: status,
                attempts: attempts,
                errorCode: errorCode,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String biteId,
                required String kind,
                required String status,
                Value<int> attempts = const Value.absent(),
                Value<String?> errorCode = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ExtractionJobEntriesCompanion.insert(
                id: id,
                biteId: biteId,
                kind: kind,
                status: status,
                attempts: attempts,
                errorCode: errorCode,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExtractionJobEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({biteId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (biteId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.biteId,
                                referencedTable:
                                    $$ExtractionJobEntriesTableReferences
                                        ._biteIdTable(db),
                                referencedColumn:
                                    $$ExtractionJobEntriesTableReferences
                                        ._biteIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ExtractionJobEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExtractionJobEntriesTable,
      ExtractionJobEntry,
      $$ExtractionJobEntriesTableFilterComposer,
      $$ExtractionJobEntriesTableOrderingComposer,
      $$ExtractionJobEntriesTableAnnotationComposer,
      $$ExtractionJobEntriesTableCreateCompanionBuilder,
      $$ExtractionJobEntriesTableUpdateCompanionBuilder,
      (ExtractionJobEntry, $$ExtractionJobEntriesTableReferences),
      ExtractionJobEntry,
      PrefetchHooks Function({bool biteId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CatalogCacheEntriesTableTableManager get catalogCacheEntries =>
      $$CatalogCacheEntriesTableTableManager(_db, _db.catalogCacheEntries);
  $$CatalogDetailCacheEntriesTableTableManager get catalogDetailCacheEntries =>
      $$CatalogDetailCacheEntriesTableTableManager(
        _db,
        _db.catalogDetailCacheEntries,
      );
  $$PersonalBookEntriesTableTableManager get personalBookEntries =>
      $$PersonalBookEntriesTableTableManager(_db, _db.personalBookEntries);
  $$ReadingCycleEntriesTableTableManager get readingCycleEntries =>
      $$ReadingCycleEntriesTableTableManager(_db, _db.readingCycleEntries);
  $$ReadingSessionEntriesTableTableManager get readingSessionEntries =>
      $$ReadingSessionEntriesTableTableManager(_db, _db.readingSessionEntries);
  $$BiteEntriesTableTableManager get biteEntries =>
      $$BiteEntriesTableTableManager(_db, _db.biteEntries);
  $$ManagedMediaEntriesTableTableManager get managedMediaEntries =>
      $$ManagedMediaEntriesTableTableManager(_db, _db.managedMediaEntries);
  $$ExtractionJobEntriesTableTableManager get extractionJobEntries =>
      $$ExtractionJobEntriesTableTableManager(_db, _db.extractionJobEntries);
}
