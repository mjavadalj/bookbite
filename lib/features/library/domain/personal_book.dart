class CatalogProvenance {
  const CatalogProvenance({
    required this.provider,
    required this.bookId,
    this.workId,
  });

  final String provider;
  final String bookId;
  final String? workId;
}

class CatalogMetadataSnapshot {
  const CatalogMetadataSnapshot({
    required this.title,
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
}

class PersonalBook {
  const PersonalBook({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.snapshot,
    this.authors = const [],
    this.provenance,
    this.archivedAt,
  });

  final String id;
  final String title;
  final List<String> authors;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CatalogMetadataSnapshot snapshot;
  final CatalogProvenance? provenance;
  final DateTime? archivedAt;
}

class PersonalBookSummary {
  const PersonalBookSummary({
    required this.id,
    required this.title,
    required this.createdAt,
    this.author,
    this.coverUrl,
  });

  final String id;
  final String title;
  final String? author;
  final Uri? coverUrl;
  final DateTime createdAt;
}

class NewPersonalBook {
  const NewPersonalBook({
    required this.id,
    required this.title,
    required this.authors,
    required this.createdAt,
    required this.snapshot,
    required this.provenance,
  });

  final String id;
  final String title;
  final List<String> authors;
  final DateTime createdAt;
  final CatalogMetadataSnapshot snapshot;
  final CatalogProvenance provenance;
}
