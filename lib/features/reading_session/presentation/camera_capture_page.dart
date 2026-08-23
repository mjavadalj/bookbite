import 'dart:async';
import 'dart:io';

import 'package:bookbite/core/presentation/localization/bookbite_localizations.dart';
import 'package:bookbite/features/reading_session/application/reading_activity_providers.dart';
import 'package:bookbite/features/reading_session/domain/reading_activity.dart';
import 'package:bookbite/features/reading_session/data/camera_capture_service.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CameraCapturePage extends ConsumerStatefulWidget {
  const CameraCapturePage({super.key});

  @override
  ConsumerState<CameraCapturePage> createState() => _CameraCapturePageState();
}

class _CameraCapturePageState extends ConsumerState<CameraCapturePage> {
  final CameraCaptureService _camera = FlutterCameraCaptureService();
  XFile? _photo;
  Object? _error;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    unawaited(_initialize());
  }

  Future<void> _initialize() async {
    try {
      await _camera.initialize();
    } catch (error) {
      _error = error;
    }
    if (mounted) setState(() {});
  }

  Future<void> _capture() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final photo = await _camera.capture();
      if (mounted) setState(() => _photo = photo);
    } catch (error) {
      if (mounted) setState(() => _error = error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  void dispose() {
    unawaited(_camera.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = BookBiteLocalizations.of(context);
    final isReview = _photo != null;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(isReview ? strings.reviewPhoto : strings.capturePage),
        actions: [
          IconButton(
            onPressed: null,
            tooltip: strings.switchCamera,
            icon: const Icon(Icons.flip_camera_android_outlined),
          ),
          IconButton(
            onPressed: null,
            tooltip: strings.gallery,
            icon: const Icon(Icons.photo_library_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: isReview
            ? _ReviewState(
                photo: _photo!,
                busy: _busy,
                onRetake: () => setState(() => _photo = null),
                onUsePhoto: () async {
                  final photo = _photo;
                  if (photo == null) return;
                  setState(() => _busy = true);
                  try {
                    final bite = await ref
                        .read(readingActivityRepositoryProvider)
                        .commitCapture(
                          temporaryPath: photo.path,
                          kind: BiteSourceKind.pageImage,
                          capturedAt: DateTime.now(),
                        );
                    unawaited(ref.read(extractionJobProcessorProvider).wake());
                    if (context.mounted) Navigator.of(context).pop(bite.id);
                  } catch (error) {
                    if (mounted) setState(() => _error = error);
                  } finally {
                    if (mounted) setState(() => _busy = false);
                  }
                },
              )
            : _CameraState(
                controller: _camera.controller,
                error: _error,
                busy: _busy,
                onRetry: () {
                  setState(() => _error = null);
                  unawaited(_initialize());
                },
                onCapture: _capture,
              ),
      ),
    );
  }
}

class _CameraState extends StatelessWidget {
  const _CameraState({
    required this.controller,
    required this.error,
    required this.busy,
    required this.onRetry,
    required this.onCapture,
  });

  final CameraController? controller;
  final Object? error;
  final bool busy;
  final VoidCallback onRetry;
  final VoidCallback onCapture;

  @override
  Widget build(BuildContext context) {
    final strings = BookBiteLocalizations.of(context);
    final cameraReady = controller?.value.isInitialized ?? false;
    return Column(
      children: [
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (cameraReady)
                CameraPreview(controller!)
              else
                const ColoredBox(color: Colors.black),
              Center(
                child: AspectRatio(
                  aspectRatio: 0.72,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.9),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              if (!cameraReady)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white70,
                          size: 40,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          error == null
                              ? strings.initializingCamera
                              : strings.cameraUnavailable,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                        if (error != null) ...[
                          const SizedBox(height: 16),
                          OutlinedButton(
                            onPressed: onRetry,
                            child: Text(strings.retry),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
          child: Column(
            children: [
              Text(
                strings.alignPage,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              IconButton.filled(
                onPressed: cameraReady && !busy ? onCapture : null,
                icon: const Icon(Icons.camera_alt_outlined),
                iconSize: 32,
                padding: const EdgeInsets.all(18),
                tooltip: strings.takePhoto,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReviewState extends StatelessWidget {
  const _ReviewState({
    required this.photo,
    required this.busy,
    required this.onRetake,
    required this.onUsePhoto,
  });

  final XFile photo;
  final bool busy;
  final VoidCallback onRetake;
  final VoidCallback onUsePhoto;

  @override
  Widget build(BuildContext context) {
    final strings = BookBiteLocalizations.of(context);
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Image.file(File(photo.path), fit: BoxFit.contain),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: busy ? null : onRetake,
                  child: Text(strings.retake),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: busy ? null : onUsePhoto,
                  child: Text(strings.usePhoto),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
