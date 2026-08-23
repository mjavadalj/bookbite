import 'dart:async';
import 'dart:io';

import 'package:bookbite/core/presentation/localization/bookbite_localizations.dart';
import 'package:bookbite/features/reading_session/application/reading_activity_providers.dart';
import 'package:bookbite/features/reading_session/data/voice_recording_service.dart';
import 'package:bookbite/features/reading_session/domain/reading_activity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

class VoiceCapturePage extends ConsumerStatefulWidget {
  const VoiceCapturePage({super.key});

  static const maximumDuration = Duration(seconds: 5);

  @override
  ConsumerState<VoiceCapturePage> createState() => _VoiceCapturePageState();
}

class _VoiceCapturePageState extends ConsumerState<VoiceCapturePage> {
  final VoiceRecordingService _recorder = RecordVoiceRecordingService();
  Timer? _timer;
  DateTime? _startedAt;
  Duration _elapsed = Duration.zero;
  String? _path;
  Object? _error;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    unawaited(_start());
  }

  Future<void> _start() async {
    try {
      if (!await _recorder.hasPermission()) {
        throw StateError('microphone_permission_denied');
      }
      final directory = await getTemporaryDirectory();
      final path =
          '${directory.path}${Platform.pathSeparator}'
          'voice-${DateTime.now().microsecondsSinceEpoch}.wav';
      await _recorder.start(path);
      _path = path;
      _startedAt = DateTime.now();
      _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
        final started = _startedAt;
        if (started == null || !mounted) return;
        final elapsed = DateTime.now().difference(started);
        setState(() => _elapsed = elapsed);
        if (elapsed >= VoiceCapturePage.maximumDuration) {
          unawaited(_stopAndSave());
        }
      });
    } catch (error) {
      if (mounted) setState(() => _error = error);
    }
  }

  Future<void> _stopAndSave() async {
    if (_saving || _startedAt == null) return;
    _timer?.cancel();
    setState(() => _saving = true);
    try {
      final recorded = await _recorder.stop() ?? _path;
      if (recorded == null) throw StateError('recording_missing');
      final bite = await ref
          .read(readingActivityRepositoryProvider)
          .commitCapture(
            temporaryPath: recorded,
            kind: BiteSourceKind.voiceRecording,
            capturedAt: _startedAt!,
          );
      unawaited(ref.read(extractionJobProcessorProvider).wake());
      if (mounted) Navigator.of(context).pop(bite.id);
    } catch (error) {
      if (mounted) setState(() => _error = error);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _cancel() async {
    _timer?.cancel();
    await _recorder.cancel();
    final path = _path;
    if (path != null) {
      final file = File(path);
      if (await file.exists()) await file.delete();
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _timer?.cancel();
    unawaited(_recorder.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = BookBiteLocalizations.of(context);
    final remaining = VoiceCapturePage.maximumDuration - _elapsed;
    final seconds = remaining.inMilliseconds.clamp(0, 5000) / 1000;
    return Scaffold(
      appBar: AppBar(
        title: Text(s.voiceCapture),
        leading: IconButton(
          onPressed: _saving ? null : _cancel,
          tooltip: s.cancel,
          icon: const Icon(Icons.close_rounded),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Icon(
                _error == null ? Icons.mic_rounded : Icons.mic_off_outlined,
                size: 72,
                semanticLabel: s.voice,
              ),
              const SizedBox(height: 24),
              Text(
                _error == null ? s.recordingVoice : s.microphoneUnavailable,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Text(
                _error == null
                    ? s.fiveSecondVoiceHelp
                    : s.microphonePermissionHelp,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              if (_error == null) ...[
                Semantics(
                  label: s.voiceTimeRemaining,
                  value: seconds.toStringAsFixed(1),
                  child: Text(
                    '${seconds.toStringAsFixed(1)} s',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _startedAt == null || _saving
                      ? null
                      : _stopAndSave,
                  icon: _saving
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.stop_rounded),
                  label: Text(_saving ? s.savingVoice : s.stopAndSave),
                ),
              ] else
                FilledButton(onPressed: _cancel, child: Text(s.back)),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _saving ? null : _cancel,
                child: Text(s.cancel),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
