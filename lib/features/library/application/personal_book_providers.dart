import 'package:bookbite/core/data/database/database_providers.dart';
import 'package:bookbite/core/data/system_services.dart';
import 'package:bookbite/features/library/application/import_catalog_book.dart';
import 'package:bookbite/features/library/application/create_manual_personal_book.dart';
import 'package:bookbite/features/library/data/drift_personal_book_repository.dart';
import 'package:bookbite/features/library/domain/personal_book_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final personalBookRepositoryProvider = Provider<PersonalBookRepository>(
  (ref) => DriftPersonalBookRepository(ref.watch(appDatabaseProvider)),
);

final importCatalogBookProvider = Provider<ImportCatalogBook>(
  (ref) => ImportCatalogBook(
    repository: ref.watch(personalBookRepositoryProvider),
    idGenerator: const UuidGenerator(),
    clock: const SystemClock(),
  ),
);

final createManualPersonalBookProvider = Provider<CreateManualPersonalBook>(
  (ref) => CreateManualPersonalBook(
    repository:
        ref.watch(personalBookRepositoryProvider)
            as ManualPersonalBookRepository,
    ids: const UuidGenerator(),
    clock: const SystemClock(),
  ),
);
