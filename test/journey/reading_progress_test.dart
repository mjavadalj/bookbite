import 'package:bookbite/features/journey/domain/reading_progress.dart';
import 'package:bookbite/features/reading_session/domain/reading_activity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('one hour advances a level using persisted session time', () {
    final now = DateTime(2026, 8, 22, 12);
    final progress = ReadingProgress.fromSessions([
      ReadingSession(
        id: 'session',
        startedAt: DateTime(2026, 8, 22, 10, 30),
        endedAt: DateTime(2026, 8, 22, 12),
      ),
    ], now: now);

    expect(progress.totalReadingTime, const Duration(minutes: 90));
    expect(progress.todayReadingTime, const Duration(minutes: 90));
    expect(progress.level, 2);
    expect(progress.levelProgress, closeTo(.5, .001));
    expect(progress.minutesToNextLevel, 30);
    expect(progress.completedSessions, 1);
  });

  test('active session contributes time up to now', () {
    final now = DateTime(2026, 8, 22, 12);
    final progress = ReadingProgress.fromSessions([
      ReadingSession(id: 'active', startedAt: DateTime(2026, 8, 22, 11, 50)),
    ], now: now);

    expect(progress.totalReadingTime, const Duration(minutes: 10));
    expect(progress.completedSessions, 0);
  });

  test('session crossing midnight is split across heatmap days', () {
    final progress = ReadingProgress.fromSessions([
      ReadingSession(
        id: 'overnight',
        startedAt: DateTime(2026, 8, 21, 23, 30),
        endedAt: DateTime(2026, 8, 22, 0, 30),
      ),
    ], now: DateTime(2026, 8, 22, 12));

    expect(
      progress.dailyReadingTime[DateTime(2026, 8, 21)],
      const Duration(minutes: 30),
    );
    expect(
      progress.dailyReadingTime[DateTime(2026, 8, 22)],
      const Duration(minutes: 30),
    );
  });

  test('streak continues from yesterday when today has no reading', () {
    final progress = ReadingProgress.fromSessions([
      ReadingSession(
        id: 'one',
        startedAt: DateTime(2026, 8, 20, 9),
        endedAt: DateTime(2026, 8, 20, 9, 20),
      ),
      ReadingSession(
        id: 'two',
        startedAt: DateTime(2026, 8, 21, 9),
        endedAt: DateTime(2026, 8, 21, 9, 20),
      ),
    ], now: DateTime(2026, 8, 22, 12));

    expect(progress.currentStreak, 2);
  });
}
