import 'package:bookbite/features/bites/domain/ocr_service.dart';
import 'package:flutter/services.dart';

/// Local-only Persian OCR adapter. Native Tesseract details stay behind the
/// application-facing [OcrService] boundary.
class TesseractOcrService implements OcrService {
  const TesseractOcrService({this.language = defaultLanguage});

  /// Persian is evaluated first while English remains available for mixed
  /// passages, names, and citations.
  static const defaultLanguage = 'fas+eng';

  final String language;
  static const _channel = MethodChannel('bookbite/ocr');

  @override
  Future<String> extractText(String managedImageReference) async {
    if (managedImageReference.trim().isEmpty) {
      throw const FormatException('OCR source reference is empty.');
    }
    final result = await _channel.invokeMethod<String>('extractText', {
      'imagePath': managedImageReference,
      'language': language,
    });
    if (result == null) throw StateError('OCR returned no text result.');
    return result.replaceAll('\r\n', '\n').trim();
  }
}
