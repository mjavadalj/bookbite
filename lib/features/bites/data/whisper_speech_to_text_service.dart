import 'dart:async';
import 'dart:io';

import 'package:bookbite/features/bites/domain/speech_to_text_service.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whisper_edge/whisper_edge.dart';

class WhisperSpeechToTextService implements SpeechToTextService {
  WhisperSpeechToTextService({this.language = defaultLanguage});

  static const defaultLanguage = 'fa';
  static const modelAssetPath = 'assets/models/ggml-tiny-q5_1.bin';
  static const modelByteLength = 32152673;
  static const maximumTranscriptionDuration = Duration(seconds: 60);
  static const _modelFileName = 'ggml-tiny-q5_1.bin';
  static const _modelLoadTimeout = Duration(seconds: 30);

  final String language;

  WhisperTranscriber? _transcriber;
  Future<WhisperTranscriber>? _loading;
  bool _cancellingTimedOutRun = false;

  @override
  Future<String> transcribe(String managedAudioReference) async {
    if (_cancellingTimedOutRun) {
      throw StateError('The previous transcription is still stopping.');
    }
    if (managedAudioReference.trim().isEmpty) {
      throw const FormatException('Speech source reference is empty.');
    }
    final source = File(managedAudioReference);
    if (!await source.exists()) throw StateError('Speech source is missing.');
    final transcriber = await _ensureTranscriber().timeout(_modelLoadTimeout);
    final pending = transcriber.transcribeWavFile(
      managedAudioReference,
      language: language,
      translate: false,
      threads: 4,
    );
    try {
      final result = await pending.timeout(
        maximumTranscriptionDuration,
        onTimeout: () {
          transcriber.cancel();
          throw TimeoutException(
            'On-device transcription exceeded one minute.',
            maximumTranscriptionDuration,
          );
        },
      );
      return result.text.replaceAll('\r\n', '\n').trim();
    } on TimeoutException {
      _transcriber = null;
      _loading = null;
      _cancellingTimedOutRun = true;
      unawaited(
        pending.then<void>(
          (_) {
            transcriber.dispose();
            _cancellingTimedOutRun = false;
          },
          onError: (Object _, StackTrace _) {
            transcriber.dispose();
            _cancellingTimedOutRun = false;
          },
        ),
      );
      rethrow;
    }
  }

  Future<WhisperTranscriber> _ensureTranscriber() async {
    final current = _transcriber;
    if (current != null) return current;
    final loading = _loading ??= _loadModel();
    try {
      return await loading;
    } catch (_) {
      if (identical(_loading, loading)) _loading = null;
      rethrow;
    }
  }

  Future<WhisperTranscriber> _loadModel() async {
    final support = await getApplicationSupportDirectory();
    final modelDirectory = Directory(
      '${support.path}${Platform.pathSeparator}models',
    );
    await modelDirectory.create(recursive: true);
    final model = File(
      '${modelDirectory.path}${Platform.pathSeparator}$_modelFileName',
    );
    if (!await model.exists() || await model.length() != modelByteLength) {
      final data = await rootBundle.load(modelAssetPath);
      if (data.lengthInBytes != modelByteLength) {
        throw StateError('Bundled speech model failed integrity validation.');
      }
      final partial = File('${model.path}.partial');
      await partial.writeAsBytes(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
        flush: true,
      );
      if (await model.exists()) await model.delete();
      await partial.rename(model.path);
    }
    final legacyModel = File(
      '${modelDirectory.path}${Platform.pathSeparator}ggml-base-q5_1.bin',
    );
    if (await legacyModel.exists()) await legacyModel.delete();
    final loaded = await WhisperTranscriber.load(model.path);
    _transcriber = loaded;
    return loaded;
  }

  void dispose() {
    final current = _transcriber;
    _transcriber = null;
    _loading = null;
    if (current == null) return;
    if (current.isBusy) {
      current.cancel();
    } else {
      current.dispose();
    }
  }
}
