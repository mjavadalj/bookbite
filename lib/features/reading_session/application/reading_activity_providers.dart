import 'dart:async';

import 'package:bookbite/core/data/database/database_providers.dart';
import 'package:bookbite/core/data/local_managed_file_storage.dart';
import 'package:bookbite/core/data/system_services.dart';
import 'package:bookbite/features/bites/application/extraction_job_processor.dart';
import 'package:bookbite/features/bites/data/tesseract_ocr_service.dart';
import 'package:bookbite/features/bites/data/whisper_speech_to_text_service.dart';
import 'package:bookbite/features/reading_session/data/drift_reading_activity_repository.dart';
import 'package:bookbite/features/reading_session/domain/reading_activity_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final readingActivityRepositoryProvider = Provider<ReadingActivityRepository>(
  (ref) => DriftReadingActivityRepository(
    database: ref.watch(appDatabaseProvider),
    files: const LocalManagedFileStorage(),
    ids: const UuidGenerator(),
  ),
);

final extractionJobProcessorProvider = Provider<ExtractionJobProcessor>((ref) {
  final speech = WhisperSpeechToTextService();
  ref.onDispose(speech.dispose);
  final processor = ExtractionJobProcessor(
    repository: ref.watch(readingActivityRepositoryProvider),
    ocr: const TesseractOcrService(),
    speech: speech,
  );
  unawaited(processor.start());
  return processor;
});
