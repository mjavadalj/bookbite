// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_book_detail_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CatalogBookDetailController)
final catalogBookDetailControllerProvider =
    CatalogBookDetailControllerFamily._();

final class CatalogBookDetailControllerProvider
    extends
        $NotifierProvider<CatalogBookDetailController, CatalogBookDetailState> {
  CatalogBookDetailControllerProvider._({
    required CatalogBookDetailControllerFamily super.from,
    required (String, String, String?) super.argument,
  }) : super(
         retry: null,
         name: r'catalogBookDetailControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$catalogBookDetailControllerHash();

  @override
  String toString() {
    return r'catalogBookDetailControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  CatalogBookDetailController create() => CatalogBookDetailController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CatalogBookDetailState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CatalogBookDetailState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CatalogBookDetailControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$catalogBookDetailControllerHash() =>
    r'7f5e970562c247d45ba0c2315b3582ed024443a8';

final class CatalogBookDetailControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          CatalogBookDetailController,
          CatalogBookDetailState,
          CatalogBookDetailState,
          CatalogBookDetailState,
          (String, String, String?)
        > {
  CatalogBookDetailControllerFamily._()
    : super(
        retry: null,
        name: r'catalogBookDetailControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CatalogBookDetailControllerProvider call(
    String provider,
    String id, [
    String? origin,
  ]) => CatalogBookDetailControllerProvider._(
    argument: (provider, id, origin),
    from: this,
  );

  @override
  String toString() => r'catalogBookDetailControllerProvider';
}

abstract class _$CatalogBookDetailController
    extends $Notifier<CatalogBookDetailState> {
  late final _$args = ref.$arg as (String, String, String?);
  String get provider => _$args.$1;
  String get id => _$args.$2;
  String? get origin => _$args.$3;

  CatalogBookDetailState build(String provider, String id, [String? origin]);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<CatalogBookDetailState, CatalogBookDetailState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CatalogBookDetailState, CatalogBookDetailState>,
              CatalogBookDetailState,
              Object?,
              Object?
            >;
    return element.handleCreate(
      ref,
      () => build(_$args.$1, _$args.$2, _$args.$3),
    );
  }
}
