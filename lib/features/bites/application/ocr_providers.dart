import 'package:bookbite/features/bites/application/ocr_job_runner.dart';
import 'package:bookbite/features/bites/data/tesseract_ocr_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ocrJobRunnerProvider = Provider<OcrJobRunner>((ref) {
  final runner = OcrJobRunner(const TesseractOcrService());
  ref.onDispose(runner.dispose);
  return runner;
});
