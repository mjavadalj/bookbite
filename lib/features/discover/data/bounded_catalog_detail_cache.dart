import 'package:bookbite/features/discover/data/catalog_detail_cache_store.dart';
import 'package:bookbite/features/discover/domain/catalog_book.dart';
import 'package:bookbite/features/discover/domain/catalog_book_detail.dart';

class CatalogDetailCache {
  CatalogDetailCache({CatalogDetailCacheStore? store, this.now = DateTime.now})
    : _store = store;

  final CatalogDetailCacheStore? _store;
  final DateTime Function() now;
  static const maxEntries = 5;
  static const freshFor = Duration(days: 7);
  final Map<String, CachedCatalogDetail> _entries = {};
  bool _hydrated = false;

  Future<CachedCatalogDetail?> read(String key) async {
    await _hydrate();
    final entry = _entries[key];
    if (entry == null) return null;
    final updated = CachedCatalogDetail(
      detail: entry.detail,
      related: entry.related,
      lastAccess: now().toUtc(),
    );
    _entries[key] = updated;
    await _persist();
    return updated;
  }

  Future<void> write(
    CatalogBookDetail detail, {
    List<CatalogBook> related = const [],
  }) async {
    await _hydrate();
    _entries[detail.identity] = CachedCatalogDetail(
      detail: detail,
      related: related,
      lastAccess: now().toUtc(),
    );
    _evict();
    await _persist();
  }

  bool isFresh(CachedCatalogDetail entry) =>
      now().toUtc().difference(entry.detail.fetchedAt) < freshFor;

  void _evict() {
    while (_entries.length > maxEntries) {
      final oldest = _entries.entries.reduce(
        (left, right) => left.value.lastAccess.isBefore(right.value.lastAccess)
            ? left
            : right,
      );
      _entries.remove(oldest.key);
    }
  }

  Future<void> _hydrate() async {
    if (_hydrated || _store == null) return;
    _hydrated = true;
    try {
      final entries = await _store.readAll();
      _entries.addAll(entries);
      _evict();
    } catch (_) {
      _entries.clear();
    }
  }

  Future<void> _persist() async {
    if (_store == null) return;
    try {
      await _store.replaceAll(_entries);
    } catch (_) {
      // Cache persistence is best effort; valid network content remains usable.
    }
  }
}
