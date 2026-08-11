import 'package:bookbite/core/data/database/database_providers.dart';
import 'package:bookbite/features/discover/application/discover_controller.dart';
import 'package:bookbite/features/discover/data/bounded_catalog_detail_cache.dart';
import 'package:bookbite/features/discover/domain/catalog_book.dart';
import 'package:bookbite/features/discover/domain/catalog_book_detail.dart';
import 'package:bookbite/features/discover/domain/catalog_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'catalog_book_detail_controller.g.dart';

enum CatalogDetailStatus { loading, data, refreshing, offline, failure }

enum CatalogRelatedStatus { idle, loading, data, failure }

class CatalogBookDetailState {
  const CatalogBookDetailState({
    this.detail,
    this.related = const [],
    this.detailStatus = CatalogDetailStatus.loading,
    this.relatedStatus = CatalogRelatedStatus.idle,
    this.failure,
    this.relatedFailure,
    this.fromCache = false,
  });

  final CatalogBookDetail? detail;
  final List<CatalogBook> related;
  final CatalogDetailStatus detailStatus;
  final CatalogRelatedStatus relatedStatus;
  final CatalogFailure? failure;
  final CatalogFailure? relatedFailure;
  final bool fromCache;

  bool get hasContent => detail != null;
  bool get isOffline =>
      detailStatus == CatalogDetailStatus.offline ||
      failure?.kind == CatalogFailureKind.offline;

  CatalogBookDetailState copyWith({
    CatalogBookDetail? detail,
    List<CatalogBook>? related,
    CatalogDetailStatus? detailStatus,
    CatalogRelatedStatus? relatedStatus,
    CatalogFailure? failure,
    bool clearFailure = false,
    CatalogFailure? relatedFailure,
    bool clearRelatedFailure = false,
    bool? fromCache,
  }) => CatalogBookDetailState(
    detail: detail ?? this.detail,
    related: related ?? this.related,
    detailStatus: detailStatus ?? this.detailStatus,
    relatedStatus: relatedStatus ?? this.relatedStatus,
    failure: clearFailure ? null : failure ?? this.failure,
    relatedFailure: clearRelatedFailure
        ? null
        : relatedFailure ?? this.relatedFailure,
    fromCache: fromCache ?? this.fromCache,
  );
}

@riverpod
class CatalogBookDetailController extends _$CatalogBookDetailController {
  late final CatalogRepository _repository;
  late final CatalogDetailCache _cache;
  bool _disposed = false;
  String? _origin;
  int _requestId = 0;

  @override
  CatalogBookDetailState build(String provider, String id, [String? origin]) {
    _origin = origin;
    _repository = ref.read(catalogRepositoryProvider);
    _cache = CatalogDetailCache(
      store: ref.read(catalogDetailCacheStoreProvider),
    );
    ref.onDispose(() => _disposed = true);
    return const CatalogBookDetailState();
  }

  Future<void> load(String language, {bool forceRefresh = false}) async {
    final request = ++_requestId;
    if (!_validRoute(provider, id, _origin)) {
      state = const CatalogBookDetailState(
        detailStatus: CatalogDetailStatus.failure,
        failure: CatalogFailure(CatalogFailureKind.invalidResponse),
      );
      return;
    }

    final cached = await _cache.read('$provider:$id');
    if (_disposed || request != _requestId) return;
    if (cached != null) {
      final fresh = _cache.isFresh(cached);
      state = state.copyWith(
        detail: cached.detail,
        related: cached.related,
        detailStatus: fresh && !forceRefresh
            ? CatalogDetailStatus.data
            : CatalogDetailStatus.refreshing,
        relatedStatus: cached.related.isEmpty
            ? CatalogRelatedStatus.idle
            : CatalogRelatedStatus.data,
        clearFailure: true,
        clearRelatedFailure: true,
        fromCache: true,
      );
      if (fresh && !forceRefresh) return;
    } else {
      state = state.copyWith(
        detailStatus: CatalogDetailStatus.loading,
        relatedStatus: CatalogRelatedStatus.idle,
        clearFailure: true,
        clearRelatedFailure: true,
        fromCache: false,
      );
    }

    try {
      final detail = await _repository.detail(
        provider: provider,
        id: id,
        language: language,
      );
      if (_disposed || request != _requestId) return;
      state = state.copyWith(
        detail: detail,
        detailStatus: CatalogDetailStatus.data,
        related: const [],
        relatedStatus: CatalogRelatedStatus.loading,
        clearFailure: true,
        fromCache: false,
      );
      if (_disposed || request != _requestId) return;
      await _cache.write(detail);
      if (_disposed || request != _requestId) return;
      try {
        final related = await _repository.related(
          book: detail,
          language: language,
          limit: 10,
        );
        if (_disposed || request != _requestId) return;
        state = state.copyWith(
          related: related,
          relatedStatus: related.isEmpty
              ? CatalogRelatedStatus.idle
              : CatalogRelatedStatus.data,
          clearRelatedFailure: true,
        );
        if (_disposed || request != _requestId) return;
        await _cache.write(detail, related: related);
      } on CatalogFailure catch (failure) {
        if (_disposed || request != _requestId) return;
        state = state.copyWith(
          relatedStatus: CatalogRelatedStatus.failure,
          relatedFailure: failure,
        );
      }
    } on CatalogFailure catch (failure) {
      if (_disposed || request != _requestId) return;
      state = state.copyWith(
        detailStatus: failure.kind == CatalogFailureKind.offline
            ? CatalogDetailStatus.offline
            : CatalogDetailStatus.failure,
        failure: failure,
      );
    }
  }

  Future<void> retry(String language) => load(language, forceRefresh: true);

  bool _validRoute(String provider, String id, String? origin) =>
      provider == 'openLibrary' &&
      RegExp(r'^OL\d+[MW]$').hasMatch(id) &&
      (origin == null || const {'browse', 'weekly', 'search'}.contains(origin));
}
