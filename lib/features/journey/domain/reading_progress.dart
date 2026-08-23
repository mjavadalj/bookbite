import 'package:bookbite/features/reading_session/domain/reading_activity.dart';

class ReadingProgress {
  const ReadingProgress({
    required this.totalReadingTime,
    required this.todayReadingTime,
    required this.dailyReadingTime,
    required this.level,
    required this.levelProgress,
    required this.currentStreak,
    required this.completedSessions,
  });

  static const dailyGoal = Duration(minutes: 30);
  static const levelLength = Duration(hours: 1);

  final Duration totalReadingTime;
  final Duration todayReadingTime;
  final Map<DateTime, Duration> dailyReadingTime;
  final int level;
  final double levelProgress;
  final int currentStreak;
  final int completedSessions;

  int get minutesToNextLevel {
    final remaining =
        levelLength -
        Duration(seconds: totalReadingTime.inSeconds % levelLength.inSeconds);
    return remaining.inMinutes == 0 ? 60 : remaining.inMinutes;
  }

  double get dailyGoalProgress =>
      (todayReadingTime.inSeconds / dailyGoal.inSeconds).clamp(0, 1);

  factory ReadingProgress.fromSessions(
    Iterable<ReadingSession> sessions, {
    required DateTime now,
  }) {
    final localNow = now.toLocal();
    final today = _day(localNow);
    final byDay = <DateTime, Duration>{};
    var total = Duration.zero;
    var completed = 0;

    for (final session in sessions) {
      var start = session.startedAt.toLocal();
      var end = (session.endedAt ?? now).toLocal();
      if (end.isAfter(localNow)) end = localNow;
      if (!end.isAfter(start)) continue;
      total += end.difference(start);
      if (session.endedAt != null) completed++;

      while (start.isBefore(end)) {
        final nextDay = DateTime(start.year, start.month, start.day + 1);
        final segmentEnd = end.isBefore(nextDay) ? end : nextDay;
        final key = _day(start);
        byDay[key] =
            (byDay[key] ?? Duration.zero) + segmentEnd.difference(start);
        start = segmentEnd;
      }
    }

    var streak = 0;
    var cursor = today;
    if ((byDay[cursor] ?? Duration.zero) == Duration.zero) {
      cursor = cursor.subtract(const Duration(days: 1));
    }
    while ((byDay[cursor] ?? Duration.zero) > Duration.zero) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    return ReadingProgress(
      totalReadingTime: total,
      todayReadingTime: byDay[today] ?? Duration.zero,
      dailyReadingTime: Map.unmodifiable(byDay),
      level: total.inSeconds ~/ levelLength.inSeconds + 1,
      levelProgress:
          (total.inSeconds % levelLength.inSeconds) / levelLength.inSeconds,
      currentStreak: streak,
      completedSessions: completed,
    );
  }

  static DateTime _day(DateTime value) =>
      DateTime(value.year, value.month, value.day);
}
