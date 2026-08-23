import 'package:bookbite/core/data/database/app_database.dart';
import 'package:bookbite/features/library/data/drift_personal_book_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('manual PersonalBook persists without catalog provenance', () async {
    final database = AppDatabase.memory();
    addTearDown(database.close);
    final repository = DriftPersonalBookRepository(database);

    final created = await repository.createManual(
      id: 'manual-1',
      title: '  My paper book  ',
      createdAt: DateTime.utc(2026, 8, 22),
    );
    final reopened = await repository.findById(created.id);

    expect(reopened?.title, 'My paper book');
    expect(reopened?.provenance, isNull);
    expect(reopened?.snapshot.title, 'My paper book');
  });
}
