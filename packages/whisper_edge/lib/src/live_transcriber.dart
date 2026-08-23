import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

import 'transcriber.dart';
import 'wav.dart';

/// One update from a [LiveTranscriber].
///
/// [committed] segments are final and will not change; [pending] is the
/// current hypothesis for the most recent audio and is rewritten on every
/// update as more context arrives.
class LiveTranscriptUpdate {
  const LiveTranscriptUpdate({
    required this.committed,
    required this.pending,
    required this.language,
    required this.isFinal,
  });

  final List<TranscriptSegment> committed;
  final List<TranscriptSegment> pending;

  /// Language whisper detected in the most recent window.
  final String language;

  /// True for the last update emitted by [LiveTranscriber.stop].
  final bool isFinal;

  String get committedText =>
      committed.map((s) => s.text).join().trim();
  String get pendingText => pending.map((s) => s.text).join().trim();

  /// Full transcript so far (committed + provisional).
  String get text => '$committedText $pendingText'.trim();
}

/// Near-real-time transcription over a live 16 kHz mono PCM feed, using the
/// sliding-window strategy of whisper.cpp's `stream` example: every [step]
/// of new audio the current window is (re)transcribed; once the window
/// grows past [window], segments older than [keep] are committed and their
/// audio is dropped.
///
/// ```dart
/// final live = LiveTranscriber(transcriber, language: 'auto');
/// live.updates.listen((u) => print('${u.committedText} | ${u.pendingText}'));
/// micStream.listen((bytes) => live.addAudio(pcm16ToFloat32(bytes)));
/// ...
/// final result = await live.stop();
/// ```
///
/// Use a small/fast model (tiny/base q5_1) so each window transcribes
/// faster than [step]; the transcriber must not be used elsewhere while a
/// live session is active.
class LiveTranscriber {
  LiveTranscriber(
    this._transcriber, {
    this.language,
    this.translate = false,
    this.threads = 0,
    this.step = const Duration(seconds: 3),
    this.window = const Duration(seconds: 12),
    this.keep = const Duration(seconds: 5),
  })  : assert(keep < window, 'keep must be shorter than window'),
        _stepSamples = step.inMilliseconds * 16,
        _windowSamples = window.inMilliseconds * 16,
        _keepSamples = keep.inMilliseconds * 16;

  final WhisperTranscriber _transcriber;
  final String? language;
  final bool translate;
  final int threads;

  /// How much new audio triggers a re-transcription.
  final Duration step;

  /// Maximum audio window fed to whisper per run.
  final Duration window;

  /// Audio kept (not committed) at the tail when the window overflows.
  final Duration keep;

  final int _stepSamples;
  final int _windowSamples;
  final int _keepSamples;

  final _controller = StreamController<LiveTranscriptUpdate>.broadcast();
  final _chunks = <Float32List>[];
  int _buffered = 0;

  /// Samples dropped from the front of the buffer since the session began
  /// (i.e. the absolute position of the buffer's first sample).
  int _dropped = 0;

  final List<TranscriptSegment> _committed = [];
  List<TranscriptSegment> _pending = const [];
  String _language = '';

  int _samplesAtLastRun = 0;
  bool _running = false;
  bool _stopped = false;
  Future<void>? _inFlight;

  /// Committed + provisional segments as they evolve.
  Stream<LiveTranscriptUpdate> get updates => _controller.stream;

  /// Whether [stop] has been called.
  bool get isStopped => _stopped;

  /// Feeds 16 kHz mono float32 samples (e.g. a microphone stream converted
  /// with [pcm16ToFloat32]). Triggers a transcription run when at least
  /// [step] of new audio has accumulated.
  void addAudio(Float32List samples) {
    if (_stopped || samples.isEmpty) return;
    _chunks.add(samples);
    _buffered += samples.length;
    final total = _dropped + _buffered;
    if (total - _samplesAtLastRun >= _stepSamples) {
      _kick(flush: false);
    }
  }

  /// Stops the session: performs one final run over the remaining audio,
  /// commits everything, emits a final update and closes [updates].
  Future<TranscriptResult> stop() async {
    if (_stopped) {
      throw StateError('LiveTranscriber is already stopped');
    }
    _stopped = true;
    final started = DateTime.now();
    await _inFlight;
    // Final flush over whatever is left in the buffer.
    if (_buffered > 0 && _dropped + _buffered > _samplesAtLastRun) {
      await _run(flush: true);
    }
    _committed.addAll(_pending);
    _pending = const [];
    _emit(isFinal: true);
    await _controller.close();
    return TranscriptResult(
      segments: List.unmodifiable(_committed),
      language: _language,
      elapsed: DateTime.now().difference(started),
    );
  }

  void _kick({required bool flush}) {
    if (_running) return;
    _running = true;
    _inFlight = _run(flush: flush).whenComplete(() => _running = false);
  }

  Future<void> _run({required bool flush}) async {
    // Need at least ~1s of audio for whisper to produce anything useful.
    if (_buffered < 16000 && !flush) return;
    if (_buffered == 0) return;

    final windowLen = math.min(_buffered, _windowSamples);
    final windowStartAbs = _dropped + _buffered - windowLen;
    final pcm = _tail(windowLen);
    _samplesAtLastRun = _dropped + _buffered;

    final TranscriptResult result;
    try {
      result = await _transcriber.transcribe(
        pcm,
        language: language,
        translate: translate,
        threads: threads,
        noContext: true,
        suppressNonSpeech: true,
      );
    } on WhisperException {
      // A cancelled/failed window is not fatal for a live session; the next
      // step retries with more audio.
      return;
    }
    if (result.language.isNotEmpty) {
      _language = result.language;
    }

    // Shift segment times from window-relative to session-absolute.
    final baseMs = windowStartAbs * 1000 ~/ whisperSampleRate;
    final segments = [
      for (final s in result.segments)
        TranscriptSegment(
          start: s.start + Duration(milliseconds: baseMs),
          end: s.end + Duration(milliseconds: baseMs),
          text: s.text,
        ),
    ];

    if (windowLen >= _windowSamples && !_stopped) {
      // Window is full: commit everything that starts before the keep zone
      // and drop the corresponding audio so the buffer stays bounded.
      final cutoffAbs = windowStartAbs + windowLen - _keepSamples;
      final cutoffMs = cutoffAbs * 1000 ~/ whisperSampleRate;
      final toCommit = [
        for (final s in segments)
          if (s.start.inMilliseconds < cutoffMs) s,
      ];
      _pending = [
        for (final s in segments)
          if (s.start.inMilliseconds >= cutoffMs) s,
      ];
      var boundaryAbs = cutoffAbs;
      if (toCommit.isNotEmpty) {
        _committed.addAll(toCommit);
        final lastEndAbs =
            toCommit.last.end.inMilliseconds * whisperSampleRate ~/ 1000;
        boundaryAbs = math.max(boundaryAbs, math.min(lastEndAbs,
            windowStartAbs + windowLen));
      }
      _dropFront(boundaryAbs - _dropped);
    } else {
      _pending = segments;
    }
    _emit(isFinal: false);

    // More than a step of audio piled up while we were transcribing.
    if (!_stopped && _dropped + _buffered - _samplesAtLastRun >= _stepSamples) {
      scheduleMicrotask(() => _kick(flush: false));
    }
  }

  void _emit({required bool isFinal}) {
    if (_controller.isClosed) return;
    _controller.add(LiveTranscriptUpdate(
      committed: List.unmodifiable(_committed),
      pending: List.unmodifiable(_pending),
      language: _language,
      isFinal: isFinal,
    ));
  }

  /// Materializes the last [n] buffered samples as one contiguous list.
  Float32List _tail(int n) {
    final out = Float32List(n);
    var remaining = n;
    var outPos = n;
    for (var i = _chunks.length - 1; i >= 0 && remaining > 0; i--) {
      final chunk = _chunks[i];
      final take = math.min(chunk.length, remaining);
      outPos -= take;
      out.setRange(outPos, outPos + take, chunk, chunk.length - take);
      remaining -= take;
    }
    return out;
  }

  /// Drops [n] samples from the front of the buffer.
  void _dropFront(int n) {
    var toDrop = math.min(n, _buffered);
    if (toDrop <= 0) return;
    _dropped += toDrop;
    _buffered -= toDrop;
    while (toDrop > 0 && _chunks.isNotEmpty) {
      final first = _chunks.first;
      if (first.length <= toDrop) {
        toDrop -= first.length;
        _chunks.removeAt(0);
      } else {
        _chunks[0] = Float32List.sublistView(first, toDrop);
        toDrop = 0;
      }
    }
  }
}
