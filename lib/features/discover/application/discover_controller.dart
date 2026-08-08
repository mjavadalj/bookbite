import 'dart:async';

import 'package:bookbite/features/discover/data/bounded_catalog_cache.dart';
import 'package:bookbite/features/discover/data/open_library_catalog_repository.dart';
import 'package:bookbite/features/discover/domain/catalog_book.dart';
import 'package:bookbite/features/discover/domain/catalog_repository.dart';
import 'package:bookbite/features/discover/domain/search_query.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  return OpenLibraryCatalogRepository(
    client: DartCatalogHttpClient(),
    contact: dotenv.env['OPEN_LIBRARY_CONTACT'] ?? '',
  );
});

final discoverControllerProvider =
    NotifierProvider<DiscoverController, DiscoverState>(DiscoverController.new);

enum CatalogStatus { initial, loading, populated, empty, error, offline }

class CatalogSection {
  const CatalogSection({
    this.books = const [],
    this.status = CatalogStatus.initial,
    this.hasMore = false,
    this.nextOffset = 0,
    this.source = CatalogSource.network,
    this.failure,
    this.total,
  });
  final List<CatalogBook> books;
  final CatalogStatus status;
  final bool hasMore;
  final int nextOffset;
  final CatalogSource source;
  final CatalogFailure? failure;
  final int? total;
  bool get hasSavedContent =>
      source == CatalogSource.freshCache ||
      source == CatalogSource.staleCache ||
      source == CatalogSource.offlineCache;

  CatalogSection copyWith({
    List<CatalogBook>? books,
    CatalogStatus? status,
    bool? hasMore,
    int? nextOffset,
    CatalogSource? source,
    CatalogFailure? failure,
    bool clearFailure = false,
    int? total,
  }) => CatalogSection(
    books: books ?? this.books,
    status: status ?? this.status,
    hasMore: hasMore ?? this.hasMore,
    nextOffset: nextOffset ?? this.nextOffset,
    source: source ?? this.source,
    failure: clearFailure ? null : failure ?? this.failure,
    total: total ?? this.total,
  );
}

class DiscoverState {
  const DiscoverState({
    this.weekly = const CatalogSection(),
    this.browse = const CatalogSection(),
    this.search = const CatalogSection(),
    this.visibleQuery = '',
    this.submittedQuery = '',
    this.pendingQuery,
    this.queryError,
  });
  final CatalogSection weekly;
  final CatalogSection browse;
  final CatalogSection search;
  final String visibleQuery;
  final String submittedQuery;
  final String? pendingQuery;
  final String? queryError;

  DiscoverState copyWith({
    CatalogSection? weekly,
    CatalogSection? browse,
    CatalogSection? search,
    String? visibleQuery,
    String? submittedQuery,
    String? pendingQuery,
    bool clearPendingQuery = false,
    String? queryError,
    bool clearQueryError = false,
  }) => DiscoverState(
    weekly: weekly ?? this.weekly,
    browse: browse ?? this.browse,
    search: search ?? this.search,
    visibleQuery: visibleQuery ?? this.visibleQuery,
    submittedQuery: submittedQuery ?? this.submittedQuery,
    pendingQuery: clearPendingQuery ? null : pendingQuery ?? this.pendingQuery,
    queryError: clearQueryError ? null : queryError ?? this.queryError,
  );
}

class DiscoverController extends Notifier<DiscoverState> {
  late final CatalogRepository _repository;
  final _cache = BoundedCatalogCache();
  Timer? _debounce;
  int _searchGeneration = 0;
  bool _loadingBrowseMore = false;
  bool _loadingSearchMore = false;

  @override
  DiscoverState build() {
    _repository = ref.read(catalogRepositoryProvider);
    ref.onDispose(() => _debounce?.cancel());
    return const DiscoverState();
  }

  Future<void> loadRoot(String language) async {
    _language = language;
    await Future.wait([_loadWeekly(), _loadBrowse()]);
  }

  void setLanguage(String language) => _language = language;

  Future<void> _loadWeekly() async {
    state = state.copyWith(
      weekly: state.weekly.copyWith(
        status: state.weekly.books.isEmpty
            ? CatalogStatus.loading
            : CatalogStatus.populated,
        clearFailure: true,
      ),
    );
    try {
      final page = await _repository.weekly(language: _language);
      final books = _unique(page.books).take(10).toList(growable: false);
      _cache.write('weekly:$_language', page);
      state = state.copyWith(weekly: _sectionFrom(page, books));
    } on CatalogFailure catch (failure) {
      final cached = _cache.read('weekly:$_language');
      state = state.copyWith(
        weekly: cached == null
            ? _failedSection(state.weekly, failure)
            : _sectionFrom(cached, cached.books, offline: true),
      );
    }
  }

  Future<void> _loadBrowse({int offset = 0, bool append = false}) async {
    if (append && _loadingBrowseMore) return;
    _loadingBrowseMore = append;
    final existing = state.browse;
    state = state.copyWith(
      browse: existing.copyWith(
        status: existing.books.isEmpty
            ? CatalogStatus.loading
            : CatalogStatus.populated,
        clearFailure: true,
      ),
    );
    try {
      final page = await _repository.browse(
        language: _language,
        offset: offset,
      );
      final books = append
          ? _unique([...existing.books, ...page.books])
          : _unique(page.books);
      final updated = _sectionFrom(page, books);
      _cache.write('browse:$_language:${offset ~/ 20}', page);
      state = state.copyWith(browse: updated);
    } on CatalogFailure catch (failure) {
      state = state.copyWith(browse: _failedSection(existing, failure));
    } finally {
      _loadingBrowseMore = false;
    }
  }

  Future<void> loadMoreBrowse() async {
    final browse = state.browse;
    if (!browse.hasMore) return;
    await _loadBrowse(offset: browse.nextOffset, append: true);
  }

  void updateSearch(String raw) {
    _debounce?.cancel();
    final parsed = SearchQuery.parse(raw);
    if (raw.runes.length > 200) {
      state = state.copyWith(
        visibleQuery: raw,
        queryError: 'tooLong',
        clearPendingQuery: true,
      );
      return;
    }
    if (parsed == null) {
      _searchGeneration++;
      state = state.copyWith(
        visibleQuery: raw,
        search: const CatalogSection(),
        submittedQuery: '',
        clearPendingQuery: true,
        clearQueryError: true,
      );
      return;
    }
    if (!parsed.isIsbn && parsed.value.runes.length < 3) {
      state = state.copyWith(
        visibleQuery: raw,
        pendingQuery: parsed.value,
        clearQueryError: true,
      );
      return;
    }
    state = state.copyWith(
      visibleQuery: raw,
      pendingQuery: parsed.value,
      clearQueryError: true,
    );
    _debounce = Timer(
      const Duration(milliseconds: 400),
      () => _performSearch(parsed),
    );
  }

  void submitSearch() {
    final parsed = SearchQuery.parse(state.visibleQuery);
    if (parsed == null || (!parsed.isIsbn && parsed.value.runes.length < 3))
      return;
    _debounce?.cancel();
    _performSearch(parsed);
  }

  void clearSearch() {
    _debounce?.cancel();
    _searchGeneration++;
    state = state.copyWith(
      visibleQuery: '',
      submittedQuery: '',
      search: const CatalogSection(),
      clearPendingQuery: true,
      clearQueryError: true,
    );
  }

  Future<void> _performSearch(
    SearchQuery query, {
    int offset = 0,
    bool append = false,
  }) async {
    final generation = ++_searchGeneration;
    final existing = state.search;
    if (append && _loadingSearchMore) return;
    _loadingSearchMore = append;
    state = state.copyWith(
      search: existing.copyWith(
        status: existing.books.isEmpty
            ? CatalogStatus.loading
            : CatalogStatus.populated,
        clearFailure: true,
      ),
      clearPendingQuery: !append,
    );
    try {
      final page = await _repository.search(
        query: query.value,
        isIsbn: query.isIsbn,
        language: _language,
        offset: offset,
      );
      if (generation != _searchGeneration) return;
      final books = append
          ? _unique([...existing.books, ...page.books])
          : _unique(page.books);
      _cache.write('search:${query.value}:$offset', page);
      state = state.copyWith(
        search: _sectionFrom(page, books),
        submittedQuery: query.value,
        clearPendingQuery: true,
      );
    } on CatalogFailure catch (failure) {
      if (generation != _searchGeneration) return;
      final cachedBooks = _cache
          .search(query.value)
          .take(100)
          .toList(growable: false);
      state = state.copyWith(
        search: cachedBooks.isNotEmpty
            ? CatalogSection(
                books: cachedBooks,
                status: CatalogStatus.populated,
                source: CatalogSource.offlineCache,
              )
            : _failedSection(existing, failure),
      );
    } finally {
      _loadingSearchMore = false;
    }
  }

  Future<void> loadMoreSearch() async {
    final search = state.search;
    final query = SearchQuery.parse(state.submittedQuery);
    if (!search.hasMore || query == null) return;
    await _performSearch(query, offset: search.nextOffset, append: true);
  }

  String _language = 'en';

  CatalogSection _sectionFrom(
    CatalogPage page,
    List<CatalogBook> books, {
    bool offline = false,
  }) => CatalogSection(
    books: books,
    status: books.isEmpty ? CatalogStatus.empty : CatalogStatus.populated,
    hasMore: page.hasMore && !offline,
    nextOffset: page.nextOffset ?? 0,
    source: offline ? CatalogSource.offlineCache : page.source,
    total: page.total,
  );

  CatalogSection _failedSection(
    CatalogSection existing,
    CatalogFailure failure,
  ) => CatalogSection(
    books: existing.books,
    status: existing.books.isEmpty
        ? (failure.kind == CatalogFailureKind.offline
              ? CatalogStatus.offline
              : CatalogStatus.error)
        : CatalogStatus.populated,
    hasMore: existing.hasMore,
    nextOffset: existing.nextOffset,
    source: existing.source,
    failure: failure,
    total: existing.total,
  );

  List<CatalogBook> _unique(Iterable<CatalogBook> books) {
    final seen = <String>{};
    return books
        .where((book) => seen.add(book.identity))
        .toList(growable: false);
  }
}
