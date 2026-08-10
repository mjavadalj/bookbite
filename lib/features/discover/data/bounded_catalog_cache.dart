import 'package:bookbite/features/discover/domain/catalog_book.dart';
import 'package:bookbite/features/discover/domain/catalog_repository.dart';
import 'package:bookbite/features/discover/data/catalog_cache_store.dart';

/// Disposable bounded cache. Persistence is an adapter concern; this class is
/// intentionally independent of personal-book storage so eviction can never
/// affect reader-owned data.
class BoundedCatalogCache {
  BoundedCatalogCache({CatalogCacheStore? store, this.now = DateTime.now})
    : _store = store;

  final CatalogCacheStore? _store;
  final DateTime Function() now;
  final Map<String, _Entry> _pages = {};
  bool _hydrated = false;
  static const maxPages = 40;
  static const maxBooks = 500;

  Future<CatalogPage?> read(String key) async {
    await _hydrate();
    final entry = _pages[key];
    if (entry == null) return null;
    entry.lastAccess = now().toUtc();
    return entry.page;
  }

  Future<void> write(String key, CatalogPage page) async {
    await _hydrate();
    _pages[key] = _Entry(page, now().toUtc());
    _evict();
    await _persist();
  }

  Future<Iterable<CatalogBook>> search(String query) async {
    await _hydrate();
    final lower = query.toLowerCase();
    final all = <String, CatalogBook>{};
    for (final entry in _pages.values) {
      for (final book in entry.page.books)
        all.putIfAbsent(book.identity, () => book);
    }
    return all.values.where(
      (book) =>
          book.title.toLowerCase().contains(lower) ||
          book.authors.any((author) => author.toLowerCase().contains(lower)) ||
          book.isbns.any(
            (isbn) => isbn
                .replaceAll(RegExp(r'[ -]'), '')
                .contains(query.replaceAll(RegExp(r'[ -]'), '')),
          ),
    );
  }

  void _evict() {
    while (_pages.length > maxPages || _bookCount > maxBooks) {
      final oldest = _pages.entries.reduce(
        (left, right) => left.value.lastAccess.isBefore(right.value.lastAccess)
            ? left
            : right,
      );
      _pages.remove(oldest.key);
    }
  }

  int get _bookCount =>
      _pages.values.fold(0, (sum, entry) => sum + entry.page.books.length);

  Future<void> _hydrate() async {
    if (_store == null || _hydrated) return;
    _hydrated = true;
    try {
      final pages = await _store.readAll();
      for (final entry in pages.entries) {
        _pages[entry.key] = _Entry(entry.value.page, entry.value.lastAccess);
      }
      _evict();
    } catch (_) {
      _pages.clear();
    }
  }

  Future<void> _persist() async {
    if (_store == null) return;
    try {
      await _store.replaceAll({
        for (final entry in _pages.entries)
          entry.key: CachedCatalogPage(
            page: entry.value.page,
            lastAccess: entry.value.lastAccess,
          ),
      });
    } catch (_) {
      // Cache persistence is best effort and never blocks catalog use.
    }
  }
}

class _Entry {
  _Entry(this.page, this.lastAccess);
  final CatalogPage page;
  DateTime lastAccess;
}
