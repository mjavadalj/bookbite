import 'package:bookbite/core/domain/clock.dart';
import 'package:bookbite/core/domain/id_generator.dart';
import 'package:bookbite/features/discover/domain/catalog_book_detail.dart';
import 'package:bookbite/features/library/application/import_catalog_book.dart';
import 'package:bookbite/features/library/domain/personal_book.dart';
import 'package:bookbite/features/library/domain/personal_book_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('imports a permanent snapshot using edition provenance', () async {
    final repository = _RecordingRepository();
    final useCase = ImportCatalogBook(
      repository: repository,
      idGenerator: _FixedIdGenerator(),
      clock: _FixedClock(),
    );

    await useCase(
      CatalogBookDetail(
        provider: 'openLibrary',
        id: 'OL10W',
        editionId: 'OL20M',
        workId: 'OL10W',
        title: 'A Book',
        authors: const ['An Author'],
        description: 'Stored locally',
        fetchedAt: DateTime.utc(2026, 8, 1),
      ),
    );

    expect(repository.imported?.id, 'personal-id');
    expect(repository.imported?.provenance.bookId, 'OL20M');
    expect(repository.imported?.provenance.workId, 'OL10W');
    expect(repository.imported?.snapshot.description, 'Stored locally');
  });
}

class _FixedIdGenerator implements IdGenerator {
  @override
  String newId() => 'personal-id';
}

class _FixedClock implements Clock {
  @override
  DateTime now() => DateTime.utc(2026, 8, 13);
}

class _RecordingRepository implements PersonalBookRepository {
  NewPersonalBook? imported;

  @override
  Future<PersonalBook> importCatalogBook(NewPersonalBook book) async {
    imported = book;
    return PersonalBook(
      id: book.id,
      title: book.title,
      authors: book.authors,
      createdAt: book.createdAt,
      updatedAt: book.createdAt,
      snapshot: book.snapshot,
      provenance: book.provenance,
    );
  }

  @override
  Future<PersonalBook?> findByCatalogIdentity({
    required String provider,
    required String bookId,
  }) async => null;

  @override
  Future<PersonalBook?> findById(String id) async => null;

  @override
  Stream<List<PersonalBookSummary>> watchActiveBooks() => const Stream.empty();
}
