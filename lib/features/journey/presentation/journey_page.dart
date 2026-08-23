import 'package:bookbite/app/theme/bookbite_theme.dart';
import 'package:bookbite/core/presentation/localization/bookbite_localizations.dart';
import 'package:bookbite/features/journey/domain/reading_progress.dart';
import 'package:bookbite/features/reading_session/application/reading_activity_providers.dart';
import 'package:bookbite/features/reading_session/domain/reading_activity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JourneyPage extends ConsumerWidget {
  const JourneyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<ReadingSession>>(
      stream: ref.watch(readingActivityRepositoryProvider).watchAllSessions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final sessions = snapshot.data ?? const <ReadingSession>[];
        final hasActiveSession = sessions.any(
          (session) => session.endedAt == null,
        );
        return _LiveJourneyContent(
          sessions: sessions,
          refreshWhileActive: hasActiveSession,
        );
      },
    );
  }
}

class _LiveJourneyContent extends StatelessWidget {
  const _LiveJourneyContent({
    required this.sessions,
    required this.refreshWhileActive,
  });

  final List<ReadingSession> sessions;
  final bool refreshWhileActive;

  @override
  Widget build(BuildContext context) {
    if (!refreshWhileActive) {
      return _content(DateTime.now());
    }
    return StreamBuilder<int>(
      stream: Stream<int>.periodic(const Duration(seconds: 1), (tick) => tick),
      builder: (context, snapshot) => _content(DateTime.now()),
    );
  }

  Widget _content(DateTime now) => _JourneyContent(
    progress: ReadingProgress.fromSessions(sessions, now: now),
  );
}

class _JourneyContent extends StatelessWidget {
  const _JourneyContent({required this.progress});
  final ReadingProgress progress;

  @override
  Widget build(BuildContext context) {
    final s = BookBiteLocalizations.of(context);
    return ListView(
      key: const PageStorageKey('journey-scroll'),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 36),
      children: [
        Text(s.journey, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 20),
        _ProfileHeader(progress: progress),
        const SizedBox(height: 16),
        _ProgressionCard(progress: progress),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _JourneyMetric(
                value: _duration(progress.totalReadingTime),
                label: s.totalReading,
                icon: Icons.timer_outlined,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _JourneyMetric(
                value: '${progress.completedSessions}',
                label: s.sessions,
                icon: Icons.menu_book_outlined,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _JourneyMetric(
                value: '${progress.currentStreak}',
                label: s.dayStreak,
                icon: Icons.local_fire_department_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.readingActivity,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(s.lastSixteenWeeks),
                const SizedBox(height: 16),
                _ContributionHeatmap(progress: progress),
                const SizedBox(height: 12),
                _HeatLegend(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _TodaySummary(progress: progress),
      ],
    );
  }

  static String _duration(Duration duration) {
    if (duration.inHours > 0) {
      final minutes = duration.inMinutes.remainder(60);
      return minutes == 0
          ? '${duration.inHours}h'
          : '${duration.inHours}h ${minutes}m';
    }
    return '${_roundedUpMinutes(duration)}m';
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.progress});
  final ReadingProgress progress;

  @override
  Widget build(BuildContext context) {
    final s = BookBiteLocalizations.of(context);
    return Row(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(
            color: BookBiteTokens.selectedSurface,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person_outline_rounded,
            size: 38,
            color: BookBiteTokens.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.reader, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 3),
              Text(s.readerLevelValue(progress.level)),
              const SizedBox(height: 3),
              Text(s.readingJourneyHelp),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProgressionCard extends StatelessWidget {
  const _ProgressionCard({required this.progress});
  final ReadingProgress progress;

  @override
  Widget build(BuildContext context) {
    final s = BookBiteLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: BookBiteTokens.primary,
        borderRadius: BorderRadius.circular(BookBiteTokens.surfaceRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.eco_outlined, color: BookBiteTokens.surface),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  s.readingProgression,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: BookBiteTokens.surface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                s.levelShortValue(progress.level),
                style: const TextStyle(
                  color: BookBiteTokens.surface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Semantics(
            label: s.levelProgressPercent(
              (progress.levelProgress * 100).round(),
            ),
            child: LinearProgressIndicator(
              value: progress.levelProgress,
              minHeight: 10,
              borderRadius: BorderRadius.circular(8),
              backgroundColor: BookBiteTokens.surface.withValues(alpha: .22),
              valueColor: const AlwaysStoppedAnimation(BookBiteTokens.surface),
            ),
          ),
          const SizedBox(height: 9),
          Text(
            s.minutesToNextLevel(progress.minutesToNextLevel),
            style: TextStyle(
              color: BookBiteTokens.surface.withValues(alpha: .86),
            ),
          ),
        ],
      ),
    );
  }
}

class _JourneyMetric extends StatelessWidget {
  const _JourneyMetric({
    required this.value,
    required this.label,
    required this.icon,
  });
  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 112),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
    decoration: BoxDecoration(
      color: BookBiteTokens.surface,
      borderRadius: BorderRadius.circular(BookBiteTokens.controlRadius),
      border: Border.all(color: BookBiteTokens.border),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: BookBiteTokens.primary),
        const SizedBox(height: 7),
        FittedBox(
          child: Text(
            value,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    ),
  );
}

class _ContributionHeatmap extends StatelessWidget {
  const _ContributionHeatmap({required this.progress});
  final ReadingProgress progress;

  static const weeks = 16;

  @override
  Widget build(BuildContext context) {
    final s = BookBiteLocalizations.of(context);
    final today = _day(DateTime.now());
    final monday = today.subtract(Duration(days: today.weekday - 1));
    final firstMonday = monday.subtract(const Duration(days: (weeks - 1) * 7));
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2, right: 6),
          child: Column(
            children: [
              _weekday(s.mondayShort),
              const SizedBox(height: 22),
              _weekday(s.wednesdayShort),
              const SizedBox(height: 22),
              _weekday(s.fridayShort),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            key: const PageStorageKey('journey-heatmap-scroll'),
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var week = 0; week < weeks; week++) ...[
                  Column(
                    children: [
                      for (var day = 0; day < 7; day++) ...[
                        _HeatCell(
                          date: firstMonday.add(Duration(days: week * 7 + day)),
                          duration:
                              progress.dailyReadingTime[firstMonday.add(
                                Duration(days: week * 7 + day),
                              )] ??
                              Duration.zero,
                          future: firstMonday
                              .add(Duration(days: week * 7 + day))
                              .isAfter(today),
                        ),
                        if (day != 6) const SizedBox(height: 4),
                      ],
                    ],
                  ),
                  if (week != weeks - 1) const SizedBox(width: 4),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  static Widget _weekday(String label) => SizedBox(
    height: 18,
    child: Text(label, style: const TextStyle(fontSize: 10)),
  );

  static DateTime _day(DateTime value) =>
      DateTime(value.year, value.month, value.day);
}

class _HeatCell extends StatelessWidget {
  const _HeatCell({
    required this.date,
    required this.duration,
    required this.future,
  });
  final DateTime date;
  final Duration duration;
  final bool future;

  @override
  Widget build(BuildContext context) {
    final s = BookBiteLocalizations.of(context);
    final minutes = _roundedUpMinutes(duration);
    final color = future ? Colors.transparent : _heatColor(minutes);
    final localizations = MaterialLocalizations.of(context);
    final label = s.activityOnDate(
      minutes,
      localizations.formatMediumDate(date),
    );
    return Tooltip(
      message: label,
      child: Semantics(
        label: label,
        child: Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: future
                ? null
                : Border.all(
                    color: BookBiteTokens.border.withValues(alpha: .7),
                  ),
          ),
        ),
      ),
    );
  }

  static Color _heatColor(int minutes) {
    if (minutes <= 0) return BookBiteTokens.selectedSurface;
    if (minutes < 15) return BookBiteTokens.activityLow;
    if (minutes < 30) return BookBiteTokens.activityMedium;
    if (minutes < 60) return BookBiteTokens.activityHigh;
    return BookBiteTokens.primary;
  }
}

class _HeatLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = BookBiteLocalizations.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(s.less, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(width: 6),
        for (final minutes in [0, 10, 20, 45, 60]) ...[
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: _HeatCell._heatColor(minutes),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 4),
        ],
        Text(s.more, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _TodaySummary extends StatelessWidget {
  const _TodaySummary({required this.progress});
  final ReadingProgress progress;

  @override
  Widget build(BuildContext context) {
    final s = BookBiteLocalizations.of(context);
    final percent = (progress.dailyGoalProgress * 100).round();
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        minVerticalPadding: 14,
        leading: const CircleAvatar(
          backgroundColor: BookBiteTokens.selectedSurface,
          foregroundColor: BookBiteTokens.primary,
          child: Icon(Icons.today_outlined),
        ),
        title: Text(s.today),
        subtitle: Text(
          s.todayReadingMinutes(_roundedUpMinutes(progress.todayReadingTime)),
        ),
        trailing: Text(
          '$percent%',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

int _roundedUpMinutes(Duration duration) => duration == Duration.zero
    ? 0
    : (duration.inSeconds / Duration.secondsPerMinute).ceil();
