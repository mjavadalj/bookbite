import 'catalog_book.dart';

enum CatalogSource { network, freshCache, staleCache, offlineCache }

enum CatalogFailureKind {
  offline,
  timeout,
  rateLimited,
  unavailable,
  invalidResponse,
  configuration,
  unexpected,
}

class CatalogFailure implements Exception {
  const CatalogFailure(this.kind, {this.retryAfter});
  final CatalogFailureKind kind;
  final Duration? retryAfter;
}

class CatalogPage {
  const CatalogPage({
    required this.books,
    required this.hasMore,
    required this.source,
    this.nextOffset,
    this.total,
    this.lastUpdated,
  });
  final List<CatalogBook> books;
  final bool hasMore;
  final CatalogSource source;
  final int? nextOffset;
  final int? total;
  final DateTime? lastUpdated;
}

abstract interface class CatalogRepository {
  Future<CatalogPage> weekly({required String language});
  Future<CatalogPage> browse({required String language, required int offset});
  Future<CatalogPage> search({
    required String query,
    required bool isIsbn,
    required String language,
    required int offset,
  });
}
