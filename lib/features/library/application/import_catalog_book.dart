import 'package:bookbite/core/domain/clock.dart';
import 'package:bookbite/core/domain/id_generator.dart';
import 'package:bookbite/features/discover/domain/catalog_book_detail.dart';
import 'package:bookbite/features/library/domain/personal_book.dart';
import 'package:bookbite/features/library/domain/personal_book_repository.dart';

class ImportCatalogBook {
  const ImportCatalogBook({
    required this.repository,
    required this.idGenerator,
    required this.clock,
  });

  final PersonalBookRepository repository;
  final IdGenerator idGenerator;
  final Clock clock;

  Future<PersonalBook> call(CatalogBookDetail detail) {
    final timestamp = clock.now().toUtc();
    return repository.importCatalogBook(
      NewPersonalBook(
        id: idGenerator.newId(),
        title: detail.title,
        authors: detail.authors,
        createdAt: timestamp,
        provenance: CatalogProvenance(
          provider: detail.provider,
          bookId: detail.editionId ?? detail.id,
          workId: detail.workId,
        ),
        snapshot: CatalogMetadataSnapshot(
          title: detail.title,
          authors: detail.authors,
          coverUrl: detail.coverUrl,
          description: detail.description,
          subjects: detail.subjects,
          publicationDate: detail.publicationDate,
          firstPublishedYear: detail.firstPublishedYear,
          edition: detail.edition,
          language: detail.language,
          originalLanguage: detail.originalLanguage,
          pageCount: detail.pageCount,
          isbn10: detail.isbn10,
          isbn13: detail.isbn13,
        ),
      ),
    );
  }
}
