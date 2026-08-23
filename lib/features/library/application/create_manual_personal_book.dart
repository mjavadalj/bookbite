import 'package:bookbite/core/domain/clock.dart';
import 'package:bookbite/core/domain/id_generator.dart';
import 'package:bookbite/features/library/domain/personal_book.dart';
import 'package:bookbite/features/library/domain/personal_book_repository.dart';

class CreateManualPersonalBook {
  const CreateManualPersonalBook({
    required this._repository,
    required this._ids,
    required this._clock,
  });

  final ManualPersonalBookRepository _repository;
  final IdGenerator _ids;
  final Clock _clock;

  Future<PersonalBook> call(String title) => _repository.createManual(
    id: _ids.newId(),
    title: title,
    createdAt: _clock.now(),
  );
}
