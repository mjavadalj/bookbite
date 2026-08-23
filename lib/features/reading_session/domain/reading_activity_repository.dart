import 'reading_activity.dart';

abstract interface class ReadingActivityRepository {
  Stream<ReadingSession?> watchActiveSession();
  Stream<List<ReadingSession>> watchAllSessions();
  Stream<List<Bite>> watchBitesForSession(String sessionId);
  Stream<List<Bite>> watchBitesForBook(String personalBookId);
  Stream<List<ReadingSession>> watchSessionsForBook(String personalBookId);

  Future<ReadingSession> startSession({String? personalBookId});
  Future<void> endActiveSession();
  Future<Bite> commitCapture({
    required String temporaryPath,
    required BiteSourceKind kind,
    required DateTime capturedAt,
  });
  Future<void> updateBiteText(String biteId, String text);
  Future<void> updateBite({
    required String biteId,
    required String text,
    required Set<BiteTag> tags,
  });
  Future<void> deleteBiteSource(String biteId);
  Future<void> retryExtraction(String biteId);
  Future<ExtractionJob?> claimNextJob();
  Future<void> completeJob(String jobId, String biteId, String text);
  Future<void> failJob(String jobId, String biteId, String errorCode);
  Future<void> recoverInterruptedJobs();
  Future<void> reconcileManagedMedia();
}
