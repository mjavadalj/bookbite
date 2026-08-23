import 'dart:math' as math;

import 'package:bookbite/app/navigation/app_router.dart';
import 'package:bookbite/app/theme/bookbite_theme.dart';
import 'package:bookbite/core/presentation/localization/bookbite_localizations.dart';
import 'package:bookbite/features/journey/domain/reading_progress.dart';
import 'package:bookbite/features/library/application/personal_book_providers.dart';
import 'package:bookbite/features/library/domain/personal_book.dart';
import 'package:bookbite/features/reading_session/application/reading_activity_providers.dart';
import 'package:bookbite/features/reading_session/domain/reading_activity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<PersonalBookSummary>>(
      stream: ref.watch(personalBookRepositoryProvider).watchActiveBooks(),
      builder: (context, bookSnapshot) => StreamBuilder<List<ReadingSession>>(
        stream: ref.watch(readingActivityRepositoryProvider).watchAllSessions(),
        builder: (context, sessionSnapshot) => _LibraryContent(
          books: bookSnapshot.data ?? const [],
          progress: ReadingProgress.fromSessions(
            sessionSnapshot.data ?? const [],
            now: DateTime.now(),
          ),
          loading:
              bookSnapshot.connectionState == ConnectionState.waiting &&
              !bookSnapshot.hasData,
          hasError: bookSnapshot.hasError,
        ),
      ),
    );
  }
}

class _LibraryContent extends StatelessWidget {
  const _LibraryContent({
    required this.books,
    required this.progress,
    required this.loading,
    required this.hasError,
  });

  final List<PersonalBookSummary> books;
  final ReadingProgress progress;
  final bool loading;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final s = BookBiteLocalizations.of(context);
    return ListView(
      key: const PageStorageKey('library-scroll'),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  const Icon(
                    Icons.local_florist_outlined,
                    color: BookBiteTokens.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'BookBite',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
            ),
            IconButton.filledTonal(
              onPressed: () => const ActiveSearchRoute().push<void>(context),
              tooltip: s.addBook,
              icon: const Icon(Icons.add_rounded),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Text(s.welcomeBack, style: Theme.of(context).textTheme.headlineMedium),
        Text(
          s.reader,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: BookBiteTokens.primary,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Text(s.libraryJourneyStory),
        const SizedBox(height: 22),
        _TodayCard(progress: progress),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _MetricTile(
                icon: Icons.auto_stories_outlined,
                value: '${books.length}',
                label: s.books,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _MetricTile(
                icon: Icons.local_fire_department_outlined,
                value: '${progress.currentStreak}',
                label: s.dayStreak,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _MetricTile(
                icon: Icons.workspace_premium_outlined,
                value: '${s.levelShort} ${progress.level}',
                label: s.readerLevel,
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 4,
          children: [
            Text(s.myBookshelf, style: Theme.of(context).textTheme.titleLarge),
            TextButton.icon(
              onPressed: () => const ActiveSearchRoute().push<void>(context),
              icon: const Icon(Icons.add_rounded),
              label: Text(s.addBook),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (loading)
          const SizedBox(
            height: 220,
            child: Center(child: CircularProgressIndicator()),
          )
        else if (hasError)
          _MessageShelf(message: s.libraryReadFailed)
        else if (books.isEmpty)
          _EmptyShelf(
            onAdd: () => const ActiveSearchRoute().push<void>(context),
          )
        else
          _BookShelf(books: books),
      ],
    );
  }
}

class _TodayCard extends StatelessWidget {
  const _TodayCard({required this.progress});
  final ReadingProgress progress;

  @override
  Widget build(BuildContext context) {
    final s = BookBiteLocalizations.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.eco_outlined,
                        size: 20,
                        color: BookBiteTokens.primary,
                      ),
                      const SizedBox(width: 7),
                      Expanded(child: Text(s.todaysProgress, maxLines: 2)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${progress.todayReadingTime.inMinutes}m',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(s.readingTime),
                ],
              ),
            ),
            Semantics(
              label: s.dailyGoalPercent(
                (progress.dailyGoalProgress * 100).round(),
              ),
              child: SizedBox.square(
                dimension: 78,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: progress.dailyGoalProgress,
                      strokeWidth: 8,
                      backgroundColor: BookBiteTokens.selectedSurface,
                      strokeCap: StrokeCap.round,
                    ),
                    Center(
                      child: Text(
                        '${(progress.dailyGoalProgress * 100).round()}%',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: BookBiteTokens.primary,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.icon,
    required this.value,
    required this.label,
  });
  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 98),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
    decoration: BoxDecoration(
      color: BookBiteTokens.surface,
      border: Border.all(color: BookBiteTokens.border),
      borderRadius: BorderRadius.circular(BookBiteTokens.controlRadius),
    ),
    child: Column(
      children: [
        Icon(icon, color: BookBiteTokens.primary),
        const SizedBox(height: 6),
        Text(
          value,
          maxLines: 1,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    ),
  );
}

class _BookShelf extends StatelessWidget {
  const _BookShelf({required this.books});
  final List<PersonalBookSummary> books;

  @override
  Widget build(BuildContext context) => Container(
    height: 252,
    padding: const EdgeInsets.fromLTRB(12, 18, 12, 14),
    decoration: BoxDecoration(
      color: BookBiteTokens.shelfWood,
      borderRadius: BorderRadius.circular(BookBiteTokens.surfaceRadius),
      border: Border.all(color: BookBiteTokens.shelfEdge),
      boxShadow: const [
        BoxShadow(
          color: BookBiteTokens.shelfShadowSoft,
          blurRadius: 18,
          offset: Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      children: [
        Expanded(
          child: ListView.separated(
            key: const PageStorageKey('library-book-spines'),
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            separatorBuilder: (_, _) => const SizedBox(width: 5),
            itemBuilder: (context, index) => Align(
              alignment: Alignment.bottomCenter,
              child: _BookSpine(
                book: books[index],
                color:
                    BookBiteTokens.bookSpinePalette[index %
                        BookBiteTokens.bookSpinePalette.length],
                height: 168 + (index % 3) * 12,
              ),
            ),
          ),
        ),
        Container(
          height: 14,
          decoration: BoxDecoration(
            color: BookBiteTokens.shelfBoard,
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(
                color: BookBiteTokens.shelfShadowStrong,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _BookSpine extends StatelessWidget {
  const _BookSpine({
    required this.book,
    required this.color,
    required this.height,
  });
  final PersonalBookSummary book;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    final foreground =
        ThemeData.estimateBrightnessForColor(color) == Brightness.dark
        ? BookBiteTokens.surface
        : BookBiteTokens.foreground;
    final width = math.max(56.0, math.min(72.0, 52 + book.title.length / 4));
    return Semantics(
      button: true,
      label: '${book.title}${book.author == null ? '' : ', ${book.author}'}',
      child: Material(
        color: color,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
        child: InkWell(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
          onTap: () => PersonalBookDetailRoute(
            personalBookId: book.id,
          ).push<void>(context),
          child: Container(
            width: width,
            height: height,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
            decoration: BoxDecoration(
              border: Border.symmetric(
                vertical: BorderSide(color: foreground.withValues(alpha: .18)),
              ),
            ),
            child: RotatedBox(
              quarterTurns: 3,
              child: Row(
                children: [
                  Icon(Icons.eco_outlined, size: 15, color: foreground),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      book.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: foreground,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyShelf extends StatelessWidget {
  const _EmptyShelf({required this.onAdd});
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final s = BookBiteLocalizations.of(context);
    return _MessageShelf(
      message: s.emptyLibrary,
      action: FilledButton.icon(
        onPressed: onAdd,
        icon: const Icon(Icons.add_rounded),
        label: Text(s.addBook),
      ),
    );
  }
}

class _MessageShelf extends StatelessWidget {
  const _MessageShelf({required this.message, this.action});
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 210),
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: BookBiteTokens.softSurface,
      borderRadius: BorderRadius.circular(BookBiteTokens.surfaceRadius),
      border: Border.all(color: BookBiteTokens.border),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.auto_stories_outlined,
          size: 48,
          color: BookBiteTokens.primary,
        ),
        const SizedBox(height: 12),
        Text(message, textAlign: TextAlign.center),
        if (action != null) ...[const SizedBox(height: 16), action!],
      ],
    ),
  );
}
