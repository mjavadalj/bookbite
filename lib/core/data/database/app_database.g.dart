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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CatalogCacheEntriesTable catalogCacheEntries =
      $CatalogCacheEntriesTable(this);
  late final $CatalogDetailCacheEntriesTable catalogDetailCacheEntries =
      $CatalogDetailCacheEntriesTable(this);
  late final $PersonalBookEntriesTable personalBookEntries =
      $PersonalBookEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    catalogCacheEntries,
    catalogDetailCacheEntries,
    personalBookEntries,
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
          (
            PersonalBookEntry,
            BaseReferences<
              _$AppDatabase,
              $PersonalBookEntriesTable,
              PersonalBookEntry
            >,
          ),
          PersonalBookEntry,
          PrefetchHooks Function()
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
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
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
      (
        PersonalBookEntry,
        BaseReferences<
          _$AppDatabase,
          $PersonalBookEntriesTable,
          PersonalBookEntry
        >,
      ),
      PersonalBookEntry,
      PrefetchHooks Function()
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
}
