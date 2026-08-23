import 'package:bookbite/app/navigation/app_router.dart';
import 'package:bookbite/app/theme/bookbite_theme.dart';
import 'package:bookbite/features/library/application/personal_book_providers.dart';
import 'package:bookbite/features/library/domain/personal_book.dart';
import 'package:bookbite/features/reading_session/application/reading_activity_providers.dart';
import 'package:bookbite/features/reading_session/domain/reading_activity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class PersonalBookDetailPage extends ConsumerWidget {
  const PersonalBookDetailPage({required this.personalBookId, super.key});
  final String personalBookId;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        onPressed: context.pop,
        tooltip: 'Back',
        icon: const Icon(Icons.arrow_back_rounded),
      ),
    ),
    body: FutureBuilder<PersonalBook?>(
      future: ref
          .watch(personalBookRepositoryProvider)
          .findById(personalBookId),
      builder: (context, bookSnapshot) {
        if (!bookSnapshot.hasData &&
            bookSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final book = bookSnapshot.data;
        if (book == null) {
          return const Center(child: Text('This book is unavailable.'));
        }
        final activity = ref.watch(readingActivityRepositoryProvider);
        return StreamBuilder<List<ReadingSession>>(
          stream: activity.watchSessionsForBook(personalBookId),
          builder: (context, sessionSnapshot) => StreamBuilder<List<Bite>>(
            stream: activity.watchBitesForBook(personalBookId),
            builder: (context, biteSnapshot) => _BookJourney(
              book: book,
              sessions: sessionSnapshot.data ?? const [],
              bites: biteSnapshot.data ?? const [],
            ),
          ),
        );
      },
    ),
  );
}

class _BookJourney extends StatelessWidget {
  const _BookJourney({
    required this.book,
    required this.sessions,
    required this.bites,
  });
  final PersonalBook book;
  final List<ReadingSession> sessions;
  final List<Bite> bites;

  @override
  Widget build(BuildContext context) {
    final completed = sessions.where((session) => session.endedAt != null);
    final duration = completed.fold<Duration>(
      Duration.zero,
      (sum, session) => sum + session.endedAt!.difference(session.startedAt),
    );
    return ListView(
      key: const PageStorageKey('personal-book-journey'),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 36),
      children: [
        _BookHeader(book: book),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _tab(context, 'Journey', selected: true)),
            const SizedBox(width: 8),
            Expanded(
              child: _tab(
                context,
                'Bites ${bites.length}',
                onTap: () => BookBitesRoute(
                  personalBookId: book.id,
                  title: book.title,
                ).push<void>(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text('Reading Journey', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(
          sessions.isEmpty
              ? 'Start a session to see this book’s story unfold.'
              : 'Your progress over time',
        ),
        const SizedBox(height: 16),
        _JourneyChart(sessions: sessions),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _Metric(label: 'Sessions', value: '${completed.length}'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _Metric(label: 'Bites', value: '${bites.length}'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _Metric(label: 'Time', value: _duration(duration)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _Metric(
                label: 'Reading Cycles',
                value: sessions.isEmpty ? '0' : '1',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _Metric(
                label: 'Longest Session',
                value: _longest(completed),
              ),
            ),
          ],
        ),
        if (sessions.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text('Sessions', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          for (final session in sessions)
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.menu_book_outlined),
                title: Text(
                  DateFormat.yMMMd().format(session.startedAt.toLocal()),
                ),
                subtitle: Text(
                  session.endedAt == null
                      ? 'In progress'
                      : _duration(
                          session.endedAt!.difference(session.startedAt),
                        ),
                ),
                trailing: session.endedAt == null
                    ? const Icon(
                        Icons.circle,
                        size: 10,
                        color: BookBiteTokens.primary,
                      )
                    : null,
              ),
            ),
        ],
      ],
    );
  }

  Widget _tab(
    BuildContext context,
    String label, {
    bool selected = false,
    VoidCallback? onTap,
  }) => Material(
    color: selected
        ? BookBiteTokens.selectedSurface
        : BookBiteTokens.softSurface,
    borderRadius: BorderRadius.circular(999),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        height: 48,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected
                  ? BookBiteTokens.foreground
                  : BookBiteTokens.secondaryText,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    ),
  );

  static String _duration(Duration value) {
    if (value.inHours > 0) {
      return '${value.inHours}h ${value.inMinutes.remainder(60)}m';
    }
    return '${value.inMinutes}m';
  }

  static String _longest(Iterable<ReadingSession> sessions) {
    var longest = Duration.zero;
    for (final session in sessions) {
      final value = session.endedAt!.difference(session.startedAt);
      if (value > longest) longest = value;
    }
    return _duration(longest);
  }
}

class _BookHeader extends StatelessWidget {
  const _BookHeader({required this.book});
  final PersonalBook book;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: SizedBox(
          width: 64,
          height: 92,
          child: book.snapshot.coverUrl == null
              ? Container(
                  color: BookBiteTokens.primary,
                  alignment: Alignment.center,
                  child: Text(
                    book.title.characters.first.toUpperCase(),
                    style: const TextStyle(
                      color: BookBiteTokens.surface,
                      fontFamily: 'serif',
                      fontSize: 28,
                    ),
                  ),
                )
              : Image.network(
                  book.snapshot.coverUrl.toString(),
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const ColoredBox(
                    color: BookBiteTokens.selectedSurface,
                    child: Icon(Icons.menu_book_outlined),
                  ),
                ),
        ),
      ),
      const SizedBox(width: 14),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(book.title, style: Theme.of(context).textTheme.titleLarge),
              if (book.authors.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(book.authors.join(', ')),
              ],
              if (book.snapshot.pageCount != null) ...[
                const SizedBox(height: 10),
                Text('${book.snapshot.pageCount} pages'),
              ],
            ],
          ),
        ),
      ),
    ],
  );
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 82),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: BookBiteTokens.surface,
      border: Border.all(color: BookBiteTokens.border),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(label, textAlign: TextAlign.center),
      ],
    ),
  );
}

class _JourneyChart extends StatelessWidget {
  const _JourneyChart({required this.sessions});
  final List<ReadingSession> sessions;

  @override
  Widget build(BuildContext context) => Semantics(
    label: '${sessions.length} reading sessions over time',
    child: Container(
      height: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BookBiteTokens.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: BookBiteTokens.border),
      ),
      child: CustomPaint(
        painter: _JourneyChartPainter(sessionCount: sessions.length),
        child: const SizedBox.expand(),
      ),
    ),
  );
}

class _JourneyChartPainter extends CustomPainter {
  const _JourneyChartPainter({required this.sessionCount});
  final int sessionCount;

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()..color = BookBiteTokens.border.withValues(alpha: .65);
    for (var i = 0; i < 4; i++) {
      final y = size.height * i / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    final path = Path()..moveTo(0, size.height * .78);
    final points = sessionCount.clamp(1, 7);
    for (var i = 1; i <= 7; i++) {
      final progress = i / 7;
      final activity = i <= points ? .18 + ((i * 37) % 50) / 100 : .78;
      path.lineTo(size.width * progress, size.height * activity);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = BookBiteTokens.primary
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(_JourneyChartPainter oldDelegate) =>
      oldDelegate.sessionCount != sessionCount;
}
