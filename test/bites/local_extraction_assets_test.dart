import 'dart:convert';
import 'dart:io';

import 'package:bookbite/features/bites/data/tesseract_ocr_service.dart';
import 'package:bookbite/features/bites/data/whisper_speech_to_text_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('English and Persian OCR data are both bundled', () async {
    final config =
        jsonDecode(await File('assets/tessdata_config.json').readAsString())
            as Map<String, Object?>;
    final files = (config['files']! as List<Object?>).cast<String>();

    expect(files, containsAll(<String>['eng.traineddata', 'fas.traineddata']));
    for (final name in files) {
      final asset = File('assets/tessdata/$name');
      expect(await asset.exists(), isTrue, reason: '$name must be bundled');
      expect(await asset.length(), greaterThan(0));
    }
    expect(TesseractOcrService.defaultLanguage, 'fas+eng');
  });

  test('the fast multilingual Whisper model and timeout are pinned', () async {
    final model = File(WhisperSpeechToTextService.modelAssetPath);

    expect(await model.exists(), isTrue);
    expect(await model.length(), WhisperSpeechToTextService.modelByteLength);
    expect(
      WhisperSpeechToTextService.maximumTranscriptionDuration,
      const Duration(seconds: 60),
    );
    expect(WhisperSpeechToTextService.defaultLanguage, 'fa');
  });
}
