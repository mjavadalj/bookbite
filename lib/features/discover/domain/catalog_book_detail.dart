import 'catalog_book.dart';

class CatalogBookDetail {
  const CatalogBookDetail({
    required this.provider,
    required this.id,
    required this.title,
    required this.fetchedAt,
    this.editionId,
    this.workId,
    this.authors = const [],
    this.coverUrl,
    this.description,
    this.subjects = const [],
    this.publicationDate,
    this.firstPublishedYear,
    this.edition,
    this.language,
    this.originalLanguage,
    this.pageCount,
    this.isbn10 = const [],
    this.isbn13 = const [],
  });

  final String provider;
  final String id;
  final String? editionId;
  final String? workId;
  final String title;
  final List<String> authors;
  final Uri? coverUrl;
  final String? description;
  final List<String> subjects;
  final String? publicationDate;
  final int? firstPublishedYear;
  final String? edition;
  final String? language;
  final String? originalLanguage;
  final int? pageCount;
  final List<String> isbn10;
  final List<String> isbn13;
  final DateTime fetchedAt;

  String get identity => '$provider:$id';

  static bool isValidIdentity(String provider, String id) =>
      provider == 'openLibrary' && RegExp(r'^OL\d+[MW]$').hasMatch(id);

  CatalogBook get summary => CatalogBook(
    provider: provider,
    id: id,
    workId: workId,
    title: title,
    authors: authors,
    edition: edition,
    language: language,
    firstPublishedYear: firstPublishedYear,
    isbns: [...isbn13, ...isbn10],
    coverUrl: coverUrl,
  );
}
