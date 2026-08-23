import 'dart:async';

import 'package:bookbite/features/bites/domain/ocr_service.dart';

enum OcrJobStatus { queued, processing, ready, failed }

class OcrJobSnapshot {
  const OcrJobSnapshot({
    required this.id,
    required this.status,
    this.text,
    this.error,
  });

  final String id;
  final OcrJobStatus status;
  final String? text;
  final String? error;
}

/// A single-worker queue for the capture slice. It keeps OCR off the UI
/// interaction and is intentionally replaceable by the persistent Drift job
/// runner from the storage migration.
class OcrJobRunner {
  OcrJobRunner(this._service);

  final OcrService _service;
  final _snapshots = <String, OcrJobSnapshot>{};
  final _references = <String, String>{};
  final _updates = StreamController<OcrJobSnapshot>.broadcast();
  final _queue = <_PendingJob>[];
  bool _running = false;

  Stream<OcrJobSnapshot> get updates => _updates.stream;

  OcrJobSnapshot? snapshot(String id) => _snapshots[id];

  List<OcrJobSnapshot> get snapshots => List.unmodifiable(_snapshots.values);

  String? imageReference(String id) => _references[id];

  Future<void> enqueue({
    required String id,
    required String imageReference,
  }) async {
    if (_snapshots.containsKey(id)) return;
    _references[id] = imageReference;
    _set(OcrJobSnapshot(id: id, status: OcrJobStatus.queued));
    _queue.add(_PendingJob(id, imageReference));
    unawaited(_drain());
  }

  Future<void> retry({
    required String id,
    required String imageReference,
  }) async {
    _queue.removeWhere((job) => job.id == id);
    _snapshots.remove(id);
    await enqueue(id: id, imageReference: imageReference);
  }

  Future<void> _drain() async {
    if (_running) return;
    _running = true;
    try {
      while (_queue.isNotEmpty) {
        final job = _queue.removeAt(0);
        _set(OcrJobSnapshot(id: job.id, status: OcrJobStatus.processing));
        try {
          final text = (await _service.extractText(
            job.imageReference,
          )).replaceAll('\r\n', '\n').trim();
          _set(
            OcrJobSnapshot(id: job.id, status: OcrJobStatus.ready, text: text),
          );
        } catch (_) {
          _set(
            OcrJobSnapshot(
              id: job.id,
              status: OcrJobStatus.failed,
              error: 'ocr_failed',
            ),
          );
        }
      }
    } finally {
      _running = false;
    }
  }

  void _set(OcrJobSnapshot snapshot) {
    _snapshots[snapshot.id] = snapshot;
    _updates.add(snapshot);
  }

  Future<void> dispose() => _updates.close();
}

class _PendingJob {
  const _PendingJob(this.id, this.imageReference);
  final String id;
  final String imageReference;
}
