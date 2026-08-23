import 'dart:io';

import 'package:bookbite/core/data/database/app_database.dart';
import 'package:bookbite/core/data/file_storage.dart';
import 'package:bookbite/core/domain/id_generator.dart';
import 'package:bookbite/features/reading_session/data/drift_reading_activity_repository.dart';
import 'package:bookbite/features/reading_session/domain/reading_activity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';

class _SequenceIds implements IdGenerator {
  int _value = 0;
  @override
  String newId() => 'id-${_value++}';
}

class _ConstantIds implements IdGenerator {
  @override
  String newId() => 'same-id';
}

class _TestFiles implements ManagedFileStorage {
  final references = <String>[];
  final deleted = <String>[];

  @override
  Future<String> persist({
    required String temporaryPath,
    required String mediaId,
  }) async {
    references.add(temporaryPath);
    return temporaryPath;
  }

  @override
  Future<void> delete(String managedReference) async {
    references.remove(managedReference);
    deleted.add(managedReference);
  }

  @override
  Future<List<String>> listManagedReferences() async => List.of(references);
}

void main() {
  late AppDatabase database;
  late DriftReadingActivityRepository repository;
  late Directory temporary;

  setUp(() async {
    database = AppDatabase.memory();
    repository = DriftReadingActivityRepository(
      database: database,
      files: _TestFiles(),
      ids: _SequenceIds(),
    );
    temporary = await Directory.systemTemp.createTemp('bookbite-session-');
  });

  tearDown(() async {
    await database.close();
    await temporary.delete(recursive: true);
  });

  test('observing the destination creates no session', () async {
    final active = await repository.watchActiveSession().first;
    expect(active, isNull);
    expect(
      await database.select(database.readingSessionEntries).get(),
      isEmpty,
    );
  });

  test('explicit start is idempotent while a session is active', () async {
    final first = await repository.startSession();
    final second = await repository.startSession();

    expect(second.id, first.id);
    expect(
      await database.select(database.readingSessionEntries).get(),
      hasLength(1),
    );
  });

  test('all-session stream exposes durable progression input', () async {
    final started = await repository.startSession();
    var sessions = await repository.watchAllSessions().first;
    expect(sessions.single.id, started.id);
    expect(sessions.single.endedAt, isNull);

    await repository.endActiveSession();
    sessions = await repository.watchAllSessions().first;
    expect(sessions.single.endedAt, isNotNull);
  });

  test(
    'captures reuse the active session and inherit book and cycle',
    () async {
      final timestamp = DateTime.utc(2026, 8, 22).millisecondsSinceEpoch;
      await database
          .into(database.personalBookEntries)
          .insert(
            PersonalBookEntriesCompanion.insert(
              id: 'book-1',
              title: 'Local book',
              authorsJson: '[]',
              snapshotJson: '{}',
              createdAt: timestamp,
              updatedAt: timestamp,
            ),
          );
      final session = await repository.startSession(personalBookId: 'book-1');
      final firstSource = File(
        '${temporary.path}${Platform.pathSeparator}first.jpg',
      );
      final secondSource = File(
        '${temporary.path}${Platform.pathSeparator}second.wav',
      );
      await firstSource.writeAsBytes([1]);
      await secondSource.writeAsBytes([2]);

      final first = await repository.commitCapture(
        temporaryPath: firstSource.path,
        kind: BiteSourceKind.pageImage,
        capturedAt: DateTime.utc(2026, 8, 22),
      );
      final second = await repository.commitCapture(
        temporaryPath: secondSource.path,
        kind: BiteSourceKind.voiceRecording,
        capturedAt: DateTime.utc(2026, 8, 22),
      );

      expect(first.readingSessionId, session.id);
      expect(second.readingSessionId, session.id);
      expect(first.personalBookId, 'book-1');
      expect(second.personalBookId, 'book-1');
      expect(first.readingCycleId, session.readingCycleId);
      expect(second.readingCycleId, session.readingCycleId);
      expect(
        await database.select(database.readingSessionEntries).get(),
        hasLength(1),
      );
    },
  );

  test(
    'durable capture creates a session, Bite, media, and queued job',
    () async {
      final source = File('${temporary.path}${Platform.pathSeparator}page.jpg');
      await source.writeAsBytes([1, 2, 3]);

      final bite = await repository.commitCapture(
        temporaryPath: source.path,
        kind: BiteSourceKind.pageImage,
        capturedAt: DateTime.utc(2026, 8, 22),
      );

      expect(bite.readingSessionId, isNotNull);
      expect(
        await database.select(database.readingSessionEntries).get(),
        hasLength(1),
      );
      expect(await database.select(database.biteEntries).get(), hasLength(1));
      expect(
        await database.select(database.managedMediaEntries).get(),
        hasLength(1),
      );
      expect(
        await database.select(database.extractionJobEntries).get(),
        hasLength(1),
      );

      final job = await repository.claimNextJob();
      expect(job?.biteId, bite.id);
      await repository.completeJob(job!.id, bite.id, 'editable text');
      await repository.updateBiteText(bite.id, 'reader edit');
      final stored = await database.select(database.biteEntries).getSingle();
      expect(stored.extractedText, 'reader edit');
      expect(stored.extractionStatus, 'ready');
    },
  );

  test('interrupted jobs are queued again and source media remains', () async {
    final source = File('${temporary.path}${Platform.pathSeparator}voice.wav');
    await source.writeAsBytes([82, 73, 70, 70]);
    await repository.commitCapture(
      temporaryPath: source.path,
      kind: BiteSourceKind.voiceRecording,
      capturedAt: DateTime.utc(2026, 8, 22),
    );
    await repository.claimNextJob();

    await repository.recoverInterruptedJobs();

    final job = await database
        .select(database.extractionJobEntries)
        .getSingle();
    expect(job.status, 'queued');
    expect(await source.exists(), isTrue);
  });

  test('a third interrupted attempt becomes a recoverable failure', () async {
    final source = File('${temporary.path}${Platform.pathSeparator}voice.wav');
    await source.writeAsBytes([82, 73, 70, 70]);
    await repository.commitCapture(
      temporaryPath: source.path,
      kind: BiteSourceKind.voiceRecording,
      capturedAt: DateTime.utc(2026, 8, 22),
    );

    for (var attempt = 0; attempt < 3; attempt++) {
      await repository.claimNextJob();
      await repository.recoverInterruptedJobs();
    }

    final job = await database
        .select(database.extractionJobEntries)
        .getSingle();
    final bite = await database.select(database.biteEntries).getSingle();
    expect(job.status, 'failed');
    expect(job.errorCode, 'interrupted');
    expect(bite.extractionStatus, 'failed');
    expect(await source.exists(), isTrue);
  });

  test('retry returns both the failed job and Bite to queued state', () async {
    final source = File('${temporary.path}${Platform.pathSeparator}page.jpg');
    await source.writeAsBytes([1, 2, 3]);
    final bite = await repository.commitCapture(
      temporaryPath: source.path,
      kind: BiteSourceKind.pageImage,
      capturedAt: DateTime.utc(2026, 8, 22),
    );
    final job = await repository.claimNextJob();
    await repository.failJob(job!.id, bite.id, 'ocr_failed');

    await repository.retryExtraction(bite.id);

    expect(
      (await database.select(database.extractionJobEntries).getSingle()).status,
      'queued',
    );
    expect(
      (await database.select(database.biteEntries).getSingle())
          .extractionStatus,
      'captured',
    );
  });

  test('failed database commit rolls back records and cleans media', () async {
    final files = _TestFiles();
    final collidingRepository = DriftReadingActivityRepository(
      database: database,
      files: files,
      ids: _ConstantIds(),
    );
    final first = File('${temporary.path}${Platform.pathSeparator}first.jpg');
    final second = File('${temporary.path}${Platform.pathSeparator}second.jpg');
    await first.writeAsBytes([1]);
    await second.writeAsBytes([2]);
    await collidingRepository.commitCapture(
      temporaryPath: first.path,
      kind: BiteSourceKind.pageImage,
      capturedAt: DateTime.utc(2026, 8, 22),
    );

    await expectLater(
      collidingRepository.commitCapture(
        temporaryPath: second.path,
        kind: BiteSourceKind.pageImage,
        capturedAt: DateTime.utc(2026, 8, 22),
      ),
      throwsA(anything),
    );

    expect(await database.select(database.biteEntries).get(), hasLength(1));
    expect(
      await database.select(database.managedMediaEntries).get(),
      hasLength(1),
    );
    expect(files.deleted, contains(second.path));
  });

  test('source deletion keeps edited text and removes media', () async {
    final source = File('${temporary.path}${Platform.pathSeparator}page.jpg');
    await source.writeAsBytes([1, 2, 3]);
    final bite = await repository.commitCapture(
      temporaryPath: source.path,
      kind: BiteSourceKind.pageImage,
      capturedAt: DateTime.utc(2026, 8, 22),
    );
    final job = await repository.claimNextJob();
    await repository.completeJob(job!.id, bite.id, 'editable text');

    await repository.deleteBiteSource(bite.id);

    expect(await database.select(database.managedMediaEntries).get(), isEmpty);
    final stored = await database.select(database.biteEntries).getSingle();
    expect(stored.extractedText, 'editable text');
    expect(stored.extractionStatus, 'ready');
  });

  test('reconciliation marks a missing queued source recoverable', () async {
    final source = File('${temporary.path}${Platform.pathSeparator}voice.wav');
    await source.writeAsBytes([82, 73, 70, 70]);
    await repository.commitCapture(
      temporaryPath: source.path,
      kind: BiteSourceKind.voiceRecording,
      capturedAt: DateTime.utc(2026, 8, 22),
    );
    await source.delete();

    await repository.reconcileManagedMedia();

    expect(await database.select(database.managedMediaEntries).get(), isEmpty);
    expect(
      (await database.select(database.biteEntries).getSingle())
          .extractionStatus,
      'failed',
    );
  });

  test(
    'books, sessions, bite edits, and tags survive a database reopen',
    () async {
      await database.close();
      final file = File(
        '${temporary.path}${Platform.pathSeparator}persistent.sqlite',
      );
      database = AppDatabase(NativeDatabase(file));
      repository = DriftReadingActivityRepository(
        database: database,
        files: _TestFiles(),
        ids: _SequenceIds(),
      );
      final now = DateTime.utc(2026, 8, 23);
      final timestamp = now.millisecondsSinceEpoch;
      await database
          .into(database.personalBookEntries)
          .insert(
            PersonalBookEntriesCompanion.insert(
              id: 'book',
              title: 'Persistent Book',
              authorsJson: '["Reader"]',
              snapshotJson: '{"version":1,"title":"Persistent Book"}',
              createdAt: timestamp,
              updatedAt: timestamp,
            ),
          );
      final session = await repository.startSession(personalBookId: 'book');
      final source = File(
        '${temporary.path}${Platform.pathSeparator}persistent.jpg',
      );
      await source.writeAsBytes([1, 2, 3]);
      final bite = await repository.commitCapture(
        temporaryPath: source.path,
        kind: BiteSourceKind.pageImage,
        capturedAt: now,
      );
      await repository.updateBite(
        biteId: bite.id,
        text: 'Saved insight',
        tags: {BiteTag.quote, BiteTag.idea},
      );
      await repository.endActiveSession();
      await database.close();

      database = AppDatabase(NativeDatabase(file));
      repository = DriftReadingActivityRepository(
        database: database,
        files: _TestFiles(),
        ids: _SequenceIds(),
      );

      expect(
        (await database.select(database.personalBookEntries).getSingle()).title,
        'Persistent Book',
      );
      final restoredSessions = await repository.watchAllSessions().first;
      expect(restoredSessions.single.id, session.id);
      expect(restoredSessions.single.endedAt, isNotNull);
      final restoredBite =
          (await repository.watchBitesForBook('book').first).single;
      expect(restoredBite.extractedText, 'Saved insight');
      expect(restoredBite.tags, {BiteTag.quote, BiteTag.idea});
    },
  );
}
