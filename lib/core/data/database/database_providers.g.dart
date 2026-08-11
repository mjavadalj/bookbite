// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'a2c854720496454719598a8b7b2cf7f2560992b8';

@ProviderFor(catalogCacheStore)
final catalogCacheStoreProvider = CatalogCacheStoreProvider._();

final class CatalogCacheStoreProvider
    extends
        $FunctionalProvider<
          CatalogCacheStore,
          CatalogCacheStore,
          CatalogCacheStore
        >
    with $Provider<CatalogCacheStore> {
  CatalogCacheStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'catalogCacheStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$catalogCacheStoreHash();

  @$internal
  @override
  $ProviderElement<CatalogCacheStore> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CatalogCacheStore create(Ref ref) {
    return catalogCacheStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CatalogCacheStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CatalogCacheStore>(value),
    );
  }
}

String _$catalogCacheStoreHash() => r'1754e62fe73334fed183a72f2e6b35318b7ab6b6';

@ProviderFor(catalogDetailCacheStore)
final catalogDetailCacheStoreProvider = CatalogDetailCacheStoreProvider._();

final class CatalogDetailCacheStoreProvider
    extends
        $FunctionalProvider<
          CatalogDetailCacheStore,
          CatalogDetailCacheStore,
          CatalogDetailCacheStore
        >
    with $Provider<CatalogDetailCacheStore> {
  CatalogDetailCacheStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'catalogDetailCacheStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$catalogDetailCacheStoreHash();

  @$internal
  @override
  $ProviderElement<CatalogDetailCacheStore> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CatalogDetailCacheStore create(Ref ref) {
    return catalogDetailCacheStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CatalogDetailCacheStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CatalogDetailCacheStore>(value),
    );
  }
}

String _$catalogDetailCacheStoreHash() =>
    r'3163692520143ac591d515f3ab200971c3a6b50e';
