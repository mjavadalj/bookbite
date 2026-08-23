import 'personal_book.dart';

abstract interface class PersonalBookRepository {
  Future<PersonalBook> importCatalogBook(NewPersonalBook book);

  Future<PersonalBook?> findById(String id);

  Future<PersonalBook?> findByCatalogIdentity({
    required String provider,
    required String bookId,
  });

  Stream<List<PersonalBookSummary>> watchActiveBooks();
}

abstract interface class ManualPersonalBookRepository {
  Future<PersonalBook> createManual({
    required String id,
    required String title,
    required DateTime createdAt,
  });
}
