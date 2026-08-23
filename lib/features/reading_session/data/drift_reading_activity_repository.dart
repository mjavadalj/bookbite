import 'dart:convert';
import 'dart:io';

import 'package:bookbite/core/data/database/app_database.dart' as database;
import 'package:bookbite/core/data/file_storage.dart';
import 'package:bookbite/core/domain/id_generator.dart';
import 'package:bookbite/features/reading_session/domain/reading_activity.dart';
import 'package:bookbite/features/reading_session/domain/reading_activity_repository.dart';
import 'package:drift/drift.dart';

class DriftReadingActivityRepository implements ReadingActivityRepository {
  DriftReadingActivityRepository({
    required this._database,
    required this._files,
    required this._ids,
  });

  final database.AppDatabase _database;
  final ManagedFileStorage _files;
  final IdGenerator _ids;

  @override
  Stream<ReadingSession?> watchActiveSession() {
    final query = _database.select(_database.readingSessionEntries)
      ..where((row) => row.endedAt.isNull())
      ..limit(1);
    return query.watchSingleOrNull().map(
      (row) => row == null ? null : _session(row),
    );
  }

  @override
  Stream<List<ReadingSession>> watchAllSessions() {
    final query = _database.select(_database.readingSessionEntries)
      ..orderBy([(row) => OrderingTerm.desc(row.startedAt)]);
    return query.watch().map(
      (rows) => rows.map(_session).toList(growable: false),
    );
  }

  @override
  Stream<List<Bite>> watchBitesForSession(String sessionId) =>
      _watchBites((row) => row.readingSessionId.equals(sessionId));

  @override
  Stream<List<Bite>> watchBitesForBook(String personalBookId) =>
      _watchBites((row) => row.personalBookId.equals(personalBookId));

  Stream<List<Bite>> _watchBites(
    Expression<bool> Function(database.BiteEntries row) predicate,
  ) {
    final query = _database.select(_database.biteEntries)
      ..where(predicate)
      ..orderBy([(row) => OrderingTerm.desc(row.createdAt)]);
    return query.watch().asyncMap((rows) async {
      final result = <Bite>[];
      for (final row in rows) {
        final media = await (_database.select(
          _database.managedMediaEntries,
        )..where((item) => item.biteId.equals(row.id))).getSingleOrNull();
        result.add(_bite(row, media?.reference));
      }
      return result;
    });
  }

  @override
  Stream<List<ReadingSession>> watchSessionsForBook(String personalBookId) {
    final query = _database.select(_database.readingSessionEntries)
      ..where((row) => row.personalBookId.equals(personalBookId))
      ..orderBy([(row) => OrderingTerm.desc(row.startedAt)]);
    return query.watch().map(
      (rows) => rows.map(_session).toList(growable: false),
    );
  }

  @override
  Future<ReadingSession> startSession({String? personalBookId}) =>
      _database.transaction(() async {
        final active = await _activeRow();
        if (active != null) return _session(active);
        final now = DateTime.now().toUtc();
        final timestamp = now.millisecondsSinceEpoch;
        String? cycleId;
        if (personalBookId != null) {
          final latest =
              await (_database.select(_database.readingCycleEntries)
                    ..where((row) => row.personalBookId.equals(personalBookId))
                    ..orderBy([(row) => OrderingTerm.desc(row.startedAt)])
                    ..limit(1))
                  .getSingleOrNull();
          if (latest != null &&
              (latest.status == 'reading' || latest.status == 'paused')) {
            cycleId = latest.id;
            if (latest.status == 'paused') {
              await (_database.update(
                _database.readingCycleEntries,
              )..where((row) => row.id.equals(latest.id))).write(
                database.ReadingCycleEntriesCompanion(
                  status: const Value('reading'),
                  updatedAt: Value(timestamp),
                ),
              );
            }
          } else {
            cycleId = _ids.newId();
            await _database
                .into(_database.readingCycleEntries)
                .insert(
                  database.ReadingCycleEntriesCompanion.insert(
                    id: cycleId,
                    personalBookId: personalBookId,
                    status: 'reading',
                    startedAt: timestamp,
                    createdAt: timestamp,
                    updatedAt: timestamp,
                  ),
                );
          }
        }
        final id = _ids.newId();
        await _database
            .into(_database.readingSessionEntries)
            .insert(
              database.ReadingSessionEntriesCompanion.insert(
                id: id,
                startedAt: timestamp,
                personalBookId: Value(personalBookId),
                readingCycleId: Value(cycleId),
                createdAt: timestamp,
                updatedAt: timestamp,
              ),
            );
        return ReadingSession(
          id: id,
          startedAt: now,
          personalBookId: personalBookId,
          readingCycleId: cycleId,
        );
      });

  @override
  Future<void> endActiveSession() async {
    final timestamp = DateTime.now().toUtc().millisecondsSinceEpoch;
    await (_database.update(
      _database.readingSessionEntries,
    )..where((row) => row.endedAt.isNull())).write(
      database.ReadingSessionEntriesCompanion(
        endedAt: Value(timestamp),
        updatedAt: Value(timestamp),
      ),
    );
  }

  @override
  Future<Bite> commitCapture({
    required String temporaryPath,
    required BiteSourceKind kind,
    required DateTime capturedAt,
  }) async {
    final mediaId = _ids.newId();
    final biteId = _ids.newId();
    final jobId = _ids.newId();
    final managed = await _files.persist(
      temporaryPath: temporaryPath,
      mediaId: mediaId,
    );
    try {
      final length = await File(managed).length();
      return await _database.transaction(() async {
        var active = await _activeRow();
        if (active == null) {
          final timestamp = capturedAt.toUtc().millisecondsSinceEpoch;
          final sessionId = _ids.newId();
          await _database
              .into(_database.readingSessionEntries)
              .insert(
                database.ReadingSessionEntriesCompanion.insert(
                  id: sessionId,
                  startedAt: timestamp,
                  createdAt: timestamp,
                  updatedAt: timestamp,
                ),
              );
          active = await (_database.select(
            _database.readingSessionEntries,
          )..where((row) => row.id.equals(sessionId))).getSingle();
        }
        final timestamp = DateTime.now().toUtc().millisecondsSinceEpoch;
        await _database
            .into(_database.biteEntries)
            .insert(
              database.BiteEntriesCompanion.insert(
                id: biteId,
                sourceKind: _kind(kind),
                extractionStatus: 'captured',
                readingSessionId: Value(active.id),
                personalBookId: Value(active.personalBookId),
                readingCycleId: Value(active.readingCycleId),
                createdAt: timestamp,
                updatedAt: timestamp,
              ),
            );
        await _database
            .into(_database.managedMediaEntries)
            .insert(
              database.ManagedMediaEntriesCompanion.insert(
                id: mediaId,
                biteId: biteId,
                kind: _kind(kind),
                reference: managed,
                byteSize: length,
                createdAt: timestamp,
              ),
            );
        await _database
            .into(_database.extractionJobEntries)
            .insert(
              database.ExtractionJobEntriesCompanion.insert(
                id: jobId,
                biteId: biteId,
                kind: _kind(kind),
                status: 'queued',
                createdAt: timestamp,
                updatedAt: timestamp,
              ),
            );
        return Bite(
          id: biteId,
          sourceKind: kind,
          extractionStatus: ExtractionStatus.captured,
          readingSessionId: active.id,
          personalBookId: active.personalBookId,
          readingCycleId: active.readingCycleId,
          mediaReference: managed,
          createdAt: _date(timestamp),
          updatedAt: _date(timestamp),
        );
      });
    } catch (_) {
      await _files.delete(managed);
      rethrow;
    }
  }

  @override
  Future<void> updateBiteText(String biteId, String text) async {
    final current = await (_database.select(
      _database.biteEntries,
    )..where((row) => row.id.equals(biteId))).getSingle();
    await updateBite(biteId: biteId, text: text, tags: _tags(current.tagsJson));
  }

  @override
  Future<void> updateBite({
    required String biteId,
    required String text,
    required Set<BiteTag> tags,
  }) async {
    final now = DateTime.now().toUtc().millisecondsSinceEpoch;
    await (_database.update(
      _database.biteEntries,
    )..where((row) => row.id.equals(biteId))).write(
      database.BiteEntriesCompanion(
        extractedText: Value(text),
        tagsJson: Value(jsonEncode(tags.map((tag) => tag.name).toList())),
        extractionStatus: const Value('ready'),
        updatedAt: Value(now),
      ),
    );
  }

  @override
  Future<void> deleteBiteSource(String biteId) async {
    final media = await (_database.select(
      _database.managedMediaEntries,
    )..where((row) => row.biteId.equals(biteId))).getSingleOrNull();
    if (media == null) return;
    await _files.delete(media.reference);
    await (_database.delete(
      _database.managedMediaEntries,
    )..where((row) => row.id.equals(media.id))).go();
    await (_database.update(
      _database.biteEntries,
    )..where((row) => row.id.equals(biteId))).write(
      database.BiteEntriesCompanion(
        updatedAt: Value(DateTime.now().toUtc().millisecondsSinceEpoch),
      ),
    );
  }

  @override
  Future<void> retryExtraction(String biteId) =>
      _database.transaction(() async {
        final now = DateTime.now().toUtc().millisecondsSinceEpoch;
        await (_database.update(
          _database.extractionJobEntries,
        )..where((row) => row.biteId.equals(biteId))).write(
          database.ExtractionJobEntriesCompanion(
            status: const Value('queued'),
            errorCode: const Value(null),
            updatedAt: Value(now),
          ),
        );
        await (_database.update(
          _database.biteEntries,
        )..where((row) => row.id.equals(biteId))).write(
          database.BiteEntriesCompanion(
            extractionStatus: const Value('captured'),
            updatedAt: Value(now),
          ),
        );
      });

  @override
  Future<ExtractionJob?> claimNextJob() => _database.transaction(() async {
    final row =
        await (_database.select(_database.extractionJobEntries)
              ..where((item) => item.status.equals('queued'))
              ..orderBy([(item) => OrderingTerm.asc(item.createdAt)])
              ..limit(1))
            .getSingleOrNull();
    if (row == null) return null;
    final media = await (_database.select(
      _database.managedMediaEntries,
    )..where((item) => item.biteId.equals(row.biteId))).getSingleOrNull();
    if (media == null || !await File(media.reference).exists()) {
      await failJob(row.id, row.biteId, 'source_missing');
      return null;
    }
    final now = DateTime.now().toUtc().millisecondsSinceEpoch;
    await (_database.update(
      _database.extractionJobEntries,
    )..where((item) => item.id.equals(row.id))).write(
      database.ExtractionJobEntriesCompanion(
        status: const Value('running'),
        attempts: Value(row.attempts + 1),
        updatedAt: Value(now),
      ),
    );
    await (_database.update(
      _database.biteEntries,
    )..where((item) => item.id.equals(row.biteId))).write(
      database.BiteEntriesCompanion(
        extractionStatus: const Value('processing'),
        updatedAt: Value(now),
      ),
    );
    return ExtractionJob(
      id: row.id,
      biteId: row.biteId,
      kind: _sourceKind(row.kind),
      mediaReference: media.reference,
      attempts: row.attempts + 1,
    );
  });

  @override
  Future<void> completeJob(String jobId, String biteId, String text) =>
      _database.transaction(() async {
        final now = DateTime.now().toUtc().millisecondsSinceEpoch;
        await (_database.update(
          _database.extractionJobEntries,
        )..where((row) => row.id.equals(jobId))).write(
          database.ExtractionJobEntriesCompanion(
            status: const Value('complete'),
            errorCode: const Value(null),
            updatedAt: Value(now),
          ),
        );
        await (_database.update(
          _database.biteEntries,
        )..where((row) => row.id.equals(biteId))).write(
          database.BiteEntriesCompanion(
            extractionStatus: const Value('ready'),
            extractedText: Value(text),
            updatedAt: Value(now),
          ),
        );
      });

  @override
  Future<void> failJob(String jobId, String biteId, String errorCode) =>
      _database.transaction(() async {
        final now = DateTime.now().toUtc().millisecondsSinceEpoch;
        await (_database.update(
          _database.extractionJobEntries,
        )..where((row) => row.id.equals(jobId))).write(
          database.ExtractionJobEntriesCompanion(
            status: const Value('failed'),
            errorCode: Value(errorCode),
            updatedAt: Value(now),
          ),
        );
        await (_database.update(
          _database.biteEntries,
        )..where((row) => row.id.equals(biteId))).write(
          database.BiteEntriesCompanion(
            extractionStatus: const Value('failed'),
            updatedAt: Value(now),
          ),
        );
      });

  @override
  Future<void> recoverInterruptedJobs() async {
    final now = DateTime.now().toUtc().millisecondsSinceEpoch;
    final running = await (_database.select(
      _database.extractionJobEntries,
    )..where((row) => row.status.equals('running'))).get();
    for (final job in running) {
      if (job.attempts >= 3) {
        await failJob(job.id, job.biteId, 'interrupted');
      } else {
        await (_database.update(
          _database.extractionJobEntries,
        )..where((row) => row.id.equals(job.id))).write(
          database.ExtractionJobEntriesCompanion(
            status: const Value('queued'),
            updatedAt: Value(now),
          ),
        );
      }
    }
  }

  @override
  Future<void> reconcileManagedMedia() async {
    final rows = await _database.select(_database.managedMediaEntries).get();
    final known = rows.map((row) => row.reference).toSet();
    for (final row in rows) {
      if (await File(row.reference).exists()) continue;
      await (_database.delete(
        _database.managedMediaEntries,
      )..where((item) => item.id.equals(row.id))).go();
      final bite = await (_database.select(
        _database.biteEntries,
      )..where((item) => item.id.equals(row.biteId))).getSingleOrNull();
      if (bite != null && bite.extractionStatus != 'ready') {
        final job = await (_database.select(
          _database.extractionJobEntries,
        )..where((item) => item.biteId.equals(row.biteId))).getSingleOrNull();
        if (job != null) {
          await failJob(job.id, row.biteId, 'source_missing');
        }
      }
    }
    for (final reference in await _files.listManagedReferences()) {
      if (!known.contains(reference)) await _files.delete(reference);
    }
  }

  Future<database.ReadingSessionEntry?> _activeRow() =>
      (_database.select(_database.readingSessionEntries)
            ..where((row) => row.endedAt.isNull())
            ..limit(1))
          .getSingleOrNull();

  ReadingSession _session(database.ReadingSessionEntry row) => ReadingSession(
    id: row.id,
    startedAt: _date(row.startedAt),
    endedAt: row.endedAt == null ? null : _date(row.endedAt!),
    personalBookId: row.personalBookId,
    readingCycleId: row.readingCycleId,
  );

  Bite _bite(database.BiteEntry row, String? mediaReference) => Bite(
    id: row.id,
    sourceKind: _sourceKind(row.sourceKind),
    extractionStatus: ExtractionStatus.values.byName(row.extractionStatus),
    extractedText: row.extractedText,
    readingSessionId: row.readingSessionId,
    personalBookId: row.personalBookId,
    readingCycleId: row.readingCycleId,
    mediaReference: mediaReference,
    tags: _tags(row.tagsJson),
    createdAt: _date(row.createdAt),
    updatedAt: _date(row.updatedAt),
  );

  String _kind(BiteSourceKind kind) => kind.name;
  BiteSourceKind _sourceKind(String value) =>
      BiteSourceKind.values.byName(value);
  DateTime _date(int value) =>
      DateTime.fromMillisecondsSinceEpoch(value, isUtc: true);

  Set<BiteTag> _tags(String value) {
    try {
      final names = (jsonDecode(value) as List).whereType<String>().toSet();
      return BiteTag.values.where((tag) => names.contains(tag.name)).toSet();
    } on FormatException {
      return const {};
    }
  }
}
