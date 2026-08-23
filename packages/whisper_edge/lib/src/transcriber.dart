import 'dart:async';
import 'dart:ffi';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

import 'bindings.dart';
import 'wav.dart';

/// A single timestamped piece of the transcript.
class TranscriptSegment {
  const TranscriptSegment({
    required this.start,
    required this.end,
    required this.text,
  });

  final Duration start;
  final Duration end;
  final String text;

  @override
  String toString() => '[$start → $end] $text';
}

/// The result of a transcription run.
class TranscriptResult {
  const TranscriptResult({
    required this.segments,
    required this.language,
    required this.elapsed,
  });

  final List<TranscriptSegment> segments;

  /// ISO 639-1 code of the language whisper detected (or was told to use).
  final String language;

  /// Wall-clock time the transcription took.
  final Duration elapsed;

  /// The full transcript as plain text.
  String get text => segments.map((s) => s.text).join().trim();

  bool get isEmpty => segments.isEmpty;
}

/// Thrown when transcription fails or is cancelled.
class WhisperException implements Exception {
  WhisperException(this.message);

  final String message;

  @override
  String toString() => 'WhisperException: $message';
}

typedef _LoadArgs = ({String modelPath, bool useGpu});
typedef _TranscribeArgs = ({
  int ctxAddress,
  Float32List pcm,
  String language,
  bool translate,
  int threads,
  int flags,
});
typedef _TranscribeRaw = ({int ret, List<(int, int, String)> segments, String lang});

// The Isolate.run closures live in these tiny top-level function scopes on
// purpose: a closure captures its whole enclosing lexical context, so
// spawning from inside a method would drag along unsendable captures
// (e.g. a caller's onProgress referencing widget state with Timers).

Future<int> _loadInWorker(_LoadArgs args) {
  return Isolate.run(() {
    final pathUtf8 = args.modelPath.toNativeUtf8();
    try {
      final ctx = WhisperEdgeBindings.instance
          .weInit(pathUtf8, args.useGpu ? 1 : 0);
      return ctx.address;
    } finally {
      malloc.free(pathUtf8);
    }
  });
}

Future<_TranscribeRaw> _transcribeInWorker(_TranscribeArgs args) {
  return Isolate.run(() {
    final bindings = WhisperEdgeBindings.instance;
    final ctx = WeContextPtr.fromAddress(args.ctxAddress);

    final buffer = malloc.allocate<Float>(args.pcm.length * 4);
    buffer.asTypedList(args.pcm.length).setAll(0, args.pcm);
    final langUtf8 = args.language.toNativeUtf8();
    try {
      final ret = bindings.weTranscribe(ctx, buffer, args.pcm.length,
          langUtf8, args.translate ? 1 : 0, args.threads, args.flags);
      if (ret != 0) {
        return (ret: ret, segments: <(int, int, String)>[], lang: '');
      }
      final n = bindings.weNSegments(ctx);
      final segments = <(int, int, String)>[
        for (var i = 0; i < n; i++)
          (
            bindings.weSegmentT0(ctx, i),
            bindings.weSegmentT1(ctx, i),
            bindings.weSegmentText(ctx, i).cast<Utf8>().toDartString(),
          ),
      ];
      final lang =
          bindings.weDetectedLanguage(ctx).cast<Utf8>().toDartString();
      return (ret: 0, segments: segments, lang: lang);
    } finally {
      malloc.free(langUtf8);
      malloc.free(buffer);
    }
  });
}

Future<Float32List> _decodeWavInWorker(String path) {
  return Isolate.run(() => decodeWavFileToWhisperPcm(path));
}

/// A loaded whisper model that can transcribe 16 kHz mono PCM audio fully
/// on-device.
///
/// ```dart
/// final transcriber = await WhisperTranscriber.load(modelPath);
/// final result = await transcriber.transcribeWavFile(wavPath,
///     onProgress: (p) => debugPrint('$p%'));
/// print(result.text);
/// transcriber.dispose();
/// ```
///
/// Heavy work runs in a worker isolate; the UI isolate stays responsive.
/// One instance runs one transcription at a time.
class WhisperTranscriber {
  WhisperTranscriber._(this._ctxAddress, this.modelPath);

  final int _ctxAddress;

  /// Path of the ggml model this transcriber was loaded from.
  final String modelPath;

  bool _disposed = false;
  bool _busy = false;

  /// Whether a transcription is currently running.
  bool get isBusy => _busy;

  /// whisper/ggml build information (enabled backends and SIMD features).
  static String get systemInfo =>
      WhisperEdgeBindings.instance.weSystemInfo().cast<Utf8>().toDartString();

  /// Loads a ggml whisper model from [modelPath].
  ///
  /// Set [useGpu] to false to force CPU-only inference (Metal is used on
  /// iOS when available; Android currently always runs on CPU).
  static Future<WhisperTranscriber> load(String modelPath,
      {bool useGpu = true}) async {
    final address =
        await _loadInWorker((modelPath: modelPath, useGpu: useGpu));
    if (address == 0) {
      throw WhisperException('Failed to load model from $modelPath');
    }
    return WhisperTranscriber._(address, modelPath);
  }

  /// Transcribes 16 kHz mono float32 [pcm] samples.
  ///
  /// [language] is an ISO 639-1 code ("en", "tr", ...); null or "auto"
  /// lets whisper detect it. [translate] converts the output to English.
  /// [threads] of 0 lets whisper pick. [onProgress] reports 0–100 while
  /// the run is in flight.
  ///
  /// [noContext] stops whisper from conditioning on its previous output —
  /// set it for sliding-window/live use. [suppressNonSpeech] drops
  /// annotations like "(music)" from the output.
  Future<TranscriptResult> transcribe(
    Float32List pcm, {
    String? language,
    bool translate = false,
    int threads = 0,
    bool noContext = false,
    bool suppressNonSpeech = false,
    void Function(int percent)? onProgress,
  }) async {
    if (_disposed) {
      throw StateError('WhisperTranscriber has been disposed');
    }
    if (_busy) {
      throw StateError('A transcription is already running on this instance');
    }
    if (pcm.isEmpty) {
      throw WhisperException('No audio samples provided');
    }
    _busy = true;

    Timer? progressTimer;
    if (onProgress != null) {
      final ctx = WeContextPtr.fromAddress(_ctxAddress);
      progressTimer = Timer.periodic(const Duration(milliseconds: 150), (_) {
        // we_progress reads an atomic int, safe while the worker runs.
        onProgress(WhisperEdgeBindings.instance.weProgress(ctx));
      });
    }

    final started = DateTime.now();
    try {
      final raw = await _transcribeInWorker((
        ctxAddress: _ctxAddress,
        pcm: pcm,
        language: language ?? 'auto',
        translate: translate,
        threads: threads,
        flags: (noContext ? weFlagNoContext : 0) |
            (suppressNonSpeech ? weFlagSuppressNonSpeech : 0),
      ));

      if (raw.ret != 0) {
        throw WhisperException('whisper_full failed with code ${raw.ret} '
            '(a cancelled run also reports failure)');
      }
      onProgress?.call(100);
      return TranscriptResult(
        segments: [
          for (final (t0, t1, text) in raw.segments)
            TranscriptSegment(
              // whisper reports centiseconds.
              start: Duration(milliseconds: t0 * 10),
              end: Duration(milliseconds: t1 * 10),
              text: text,
            ),
        ],
        language: raw.lang,
        elapsed: DateTime.now().difference(started),
      );
    } finally {
      progressTimer?.cancel();
      _busy = false;
    }
  }

  /// Decodes a WAV file (any common encoding/sample rate) and transcribes it.
  Future<TranscriptResult> transcribeWavFile(
    String path, {
    String? language,
    bool translate = false,
    int threads = 0,
    void Function(int percent)? onProgress,
  }) async {
    final pcm = await _decodeWavInWorker(path);
    return transcribe(pcm,
        language: language,
        translate: translate,
        threads: threads,
        onProgress: onProgress);
  }

  /// Requests cancellation of the in-flight [transcribe] call. The pending
  /// future completes with a [WhisperException].
  void cancel() {
    if (_disposed) return;
    WhisperEdgeBindings.instance.weAbort(WeContextPtr.fromAddress(_ctxAddress));
  }

  /// Frees the native model. The instance is unusable afterwards.
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    WhisperEdgeBindings.instance.weFree(WeContextPtr.fromAddress(_ctxAddress));
  }
}
