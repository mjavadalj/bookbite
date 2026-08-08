import 'package:bookbite/features/discover/domain/catalog_book.dart';
import 'package:bookbite/features/discover/domain/catalog_repository.dart';

/// Disposable bounded cache. Persistence is an adapter concern; this class is
/// intentionally independent of personal-book storage so eviction can never
/// affect reader-owned data.
class BoundedCatalogCache {
  BoundedCatalogCache({this.now = DateTime.now});
  final DateTime Function() now;
  final Map<String, _Entry> _pages = {};
  static const maxPages = 40;
  static const maxBooks = 500;

  CatalogPage? read(String key) {
    final entry = _pages[key];
    if (entry == null) return null;
    entry.lastAccess = now().toUtc();
    return entry.page;
  }

  void write(String key, CatalogPage page) {
    _pages[key] = _Entry(page, now().toUtc());
    _evict();
  }

  Iterable<CatalogBook> search(String query) {
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
}

class _Entry {
  _Entry(this.page, this.lastAccess);
  final CatalogPage page;
  DateTime lastAccess;
}
