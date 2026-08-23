import 'dart:async';

import 'package:bookbite/features/bites/domain/ocr_service.dart';
import 'package:bookbite/features/bites/domain/speech_to_text_service.dart';
import 'package:bookbite/features/reading_session/domain/reading_activity.dart';
import 'package:bookbite/features/reading_session/domain/reading_activity_repository.dart';

class ExtractionJobProcessor {
  ExtractionJobProcessor({
    required this._repository,
    required this._ocr,
    required this._speech,
  });

  final ReadingActivityRepository _repository;
  final OcrService _ocr;
  final SpeechToTextService _speech;
  bool _running = false;

  Future<void> start() async {
    await _repository.reconcileManagedMedia();
    await _repository.recoverInterruptedJobs();
    await wake();
  }

  Future<void> wake() async {
    if (_running) return;
    _running = true;
    try {
      while (true) {
        final job = await _repository.claimNextJob();
        if (job == null) break;
        try {
          final text = switch (job.kind) {
            BiteSourceKind.pageImage => await _ocr.extractText(
              job.mediaReference,
            ),
            BiteSourceKind.voiceRecording => await _speech.transcribe(
              job.mediaReference,
            ),
          };
          await _repository.completeJob(job.id, job.biteId, text);
        } catch (_) {
          await _repository.failJob(
            job.id,
            job.biteId,
            job.kind == BiteSourceKind.pageImage
                ? 'ocr_failed'
                : 'transcription_failed',
          );
        }
      }
    } finally {
      _running = false;
    }
  }
}
