class CatalogBook {
  const CatalogBook({
    required this.provider,
    required this.id,
    required this.title,
    this.workId,
    this.authors = const [],
    this.edition,
    this.language,
    this.firstPublishedYear,
    this.isbns = const [],
    this.coverUrl,
  }) : assert(provider != ''),
       assert(id != ''),
       assert(title != '');

  final String provider;
  final String id;
  final String title;
  final String? workId;
  final List<String> authors;
  final String? edition;
  final String? language;
  final int? firstPublishedYear;
  final List<String> isbns;
  final Uri? coverUrl;

  String get identity => '$provider:$id';
}
