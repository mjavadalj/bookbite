import 'dart:async';
import 'dart:io';

import 'package:bookbite/app/navigation/app_router.dart';
import 'package:bookbite/app/theme/bookbite_theme.dart';
import 'package:bookbite/core/presentation/localization/bookbite_localizations.dart';
import 'package:bookbite/features/library/application/personal_book_providers.dart';
import 'package:bookbite/features/bites/presentation/bite_collection_page.dart'
    as bites_ui;
import 'package:bookbite/features/library/domain/personal_book.dart';
import 'package:bookbite/features/reading_session/application/reading_activity_providers.dart';
import 'package:bookbite/features/reading_session/domain/reading_activity.dart';
import 'package:bookbite/features/reading_session/domain/reading_activity_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReadingSessionPage extends ConsumerStatefulWidget {
  const ReadingSessionPage({super.key});

  @override
  ConsumerState<ReadingSessionPage> createState() => _ReadingSessionPageState();
}

class _ReadingSessionPageState extends ConsumerState<ReadingSessionPage> {
  PersonalBookSummary? _selected;
  bool _busy = false;

  Future<void> _start(String? personalBookId) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await ref
          .read(readingActivityRepositoryProvider)
          .startSession(personalBookId: personalBookId);
      if (mounted) setState(() => _selected = null);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _capturePhoto() async {
    await const ReadingSessionCaptureRoute().push<String>(context);
  }

  Future<void> _captureVoice() async {
    await const ReadingSessionVoiceCaptureRoute().push<String>(context);
  }

  Future<void> _retryExtraction(String biteId) async {
    await ref.read(readingActivityRepositoryProvider).retryExtraction(biteId);
    await ref.read(extractionJobProcessorProvider).wake();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(extractionJobProcessorProvider);
    final repository = ref.watch(readingActivityRepositoryProvider);
    return StreamBuilder<ReadingSession?>(
      stream: repository.watchActiveSession(),
      builder: (context, activeSnapshot) {
        final active = activeSnapshot.data;
        if (active != null) {
          return StreamBuilder<List<PersonalBookSummary>>(
            stream: ref
                .watch(personalBookRepositoryProvider)
                .watchActiveBooks(),
            builder: (context, booksSnapshot) {
              final books = booksSnapshot.data ?? const <PersonalBookSummary>[];
              final book = books
                  .where((item) => item.id == active.personalBookId)
                  .firstOrNull;
              return _ActiveSession(
                session: active,
                book: book,
                repository: repository,
                busy: _busy,
                onStart: () {},
                onStop: () => _confirmEnd(repository),
                onPhoto: _capturePhoto,
                onVoice: _captureVoice,
                onRetryExtraction: _retryExtraction,
              );
            },
          );
        }
        if (_selected != null) {
          return _ActiveSession(
            session: null,
            book: _selected!,
            repository: repository,
            busy: _busy,
            onStart: () => _start(_selected!.id),
            onStop: () => setState(() => _selected = null),
            onPhoto: _capturePhoto,
            onVoice: _captureVoice,
            onRetryExtraction: _retryExtraction,
          );
        }
        return StreamBuilder<List<PersonalBookSummary>>(
          stream: ref.watch(personalBookRepositoryProvider).watchActiveBooks(),
          builder: (context, snapshot) {
            return StreamBuilder<List<ReadingSession>>(
              stream: repository.watchAllSessions(),
              builder: (context, sessionsSnapshot) => _IdleSession(
                books: snapshot.data ?? const <PersonalBookSummary>[],
                sessions: sessionsSnapshot.data ?? const <ReadingSession>[],
                loading:
                    snapshot.connectionState == ConnectionState.waiting ||
                    sessionsSnapshot.connectionState == ConnectionState.waiting,
                onSelect: (book) => setState(() => _selected = book),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _confirmEnd(ReadingActivityRepository repository) async {
    final s = BookBiteLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(s.endSessionQuestion),
        content: Text(s.endSessionHelp),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(s.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(s.endSession),
          ),
        ],
      ),
    );
    if (confirmed == true) await repository.endActiveSession();
  }
}

class _IdleSession extends StatelessWidget {
  const _IdleSession({
    required this.books,
    required this.sessions,
    required this.loading,
    required this.onSelect,
  });

  final List<PersonalBookSummary> books;
  final List<ReadingSession> sessions;
  final bool loading;
  final ValueChanged<PersonalBookSummary> onSelect;

  @override
  Widget build(BuildContext context) {
    final s = BookBiteLocalizations.of(context);
    final sessionsByBook = <String, List<ReadingSession>>{};
    for (final session in sessions) {
      final bookId = session.personalBookId;
      if (bookId != null) {
        sessionsByBook.putIfAbsent(bookId, () => []).add(session);
      }
    }
    final continuing =
        books
            .where((book) => sessionsByBook.containsKey(book.id))
            .toList(growable: false)
          ..sort(
            (left, right) => _latestSession(sessionsByBook[right.id]!).startedAt
                .compareTo(_latestSession(sessionsByBook[left.id]!).startedAt),
          );

    return CustomScrollView(
      key: const PageStorageKey('reading-session-book-picker'),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    s.startSessionTitle,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontFamily: 'serif',
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  s.chooseBookToBegin,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: BookBiteTokens.primary,
                    fontSize: 13.5,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (loading)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: CircularProgressIndicator()),
          )
        else if (books.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(s.noLibraryBooks),
            ),
          )
        else ...[
          if (continuing.isNotEmpty) ...[
            SliverToBoxAdapter(child: _SectionLabel(s.continueReading)),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 252,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 6),
                  itemCount: continuing.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final book = continuing[index];
                    return _ContinueBookCard(
                      book: book,
                      sessions: sessionsByBook[book.id]!,
                      onPressed: () => onSelect(book),
                    );
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 22)),
          ],
          SliverToBoxAdapter(child: _SectionLabel(s.yourLibrary)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList.separated(
              itemCount: books.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final book = books[index];
                final history = sessionsByBook[book.id];
                return _LibraryBookRow(
                  book: book,
                  latestSession: history == null
                      ? null
                      : _latestSession(history),
                  onPressed: () => onSelect(book),
                );
              },
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
    child: Text(
      label.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: BookBiteTokens.secondaryText,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
      ),
    ),
  );
}

class _ContinueBookCard extends StatelessWidget {
  const _ContinueBookCard({
    required this.book,
    required this.sessions,
    required this.onPressed,
  });

  final PersonalBookSummary book;
  final List<ReadingSession> sessions;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final s = BookBiteLocalizations.of(context);
    final latest = _latestSession(sessions);
    final endedAt = latest.endedAt ?? DateTime.now().toUtc();
    final rawDuration = endedAt.difference(latest.startedAt);
    final duration = rawDuration.isNegative ? Duration.zero : rawDuration;
    final progress =
        (duration.inSeconds / const Duration(minutes: 30).inSeconds)
            .clamp(0.04, 1.0)
            .toDouble();

    return Semantics(
      button: true,
      label: '${book.title}, ${book.author ?? s.authorUnavailable}',
      child: SizedBox(
        width: 124,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _BookCover(book: book, width: 124, height: 172),
                    const PositionedDirectional(
                      top: -5,
                      end: 13,
                      child: Icon(
                        Icons.bookmark_rounded,
                        size: 31,
                        color: BookBiteTokens.canvas,
                        shadows: [
                          Shadow(color: Color(0x33000000), blurRadius: 3),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                Text(
                  book.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: BookBiteTokens.foreground,
                    fontFamily: 'serif',
                    fontSize: 14.5,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  book.author ?? s.authorUnavailable,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: BookBiteTokens.secondaryText,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 2,
                    backgroundColor: const Color(0x1A26231E),
                    color: const Color(0xFF7B3131),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  s.readingMinutes(duration.inMinutes),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: BookBiteTokens.secondaryText,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LibraryBookRow extends StatelessWidget {
  const _LibraryBookRow({
    required this.book,
    required this.latestSession,
    required this.onPressed,
  });

  final PersonalBookSummary book;
  final ReadingSession? latestSession;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final s = BookBiteLocalizations.of(context);
    final days = latestSession == null
        ? null
        : DateTime.now().toUtc().difference(latestSession!.startedAt).inDays;
    final status = days == null
        ? s.notStarted
        : s.startedDaysAgo(days.clamp(0, 9999));

    return Semantics(
      button: true,
      label: '${book.title}, ${book.author ?? s.authorUnavailable}, $status',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 90),
            child: Row(
              children: [
                _BookCover(book: book, width: 44, height: 62),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontFamily: 'serif',
                          fontSize: 15.5,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        book.author ?? s.authorUnavailable,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: BookBiteTokens.secondaryText,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  status,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: latestSession == null
                        ? BookBiteTokens.secondaryText
                        : const Color(0xFF7B3131),
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BookCover extends StatelessWidget {
  const _BookCover({
    required this.book,
    required this.width,
    required this.height,
  });

  final PersonalBookSummary book;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final palette = <Color>[
      const Color(0xFF4B5A4E),
      const Color(0xFFA98F5C),
      const Color(0xFF26231E),
      const Color(0xFF6E6B4C),
      const Color(0xFF7B3131),
    ];
    final color = palette[(book.id.hashCode & 0x7fffffff) % palette.length];
    final placeholder = ColoredBox(
      color: color,
      child: width >= 100
          ? Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  book.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: BookBiteTokens.surface,
                    fontFamily: 'serif',
                    fontSize: 13.5,
                    height: 1.2,
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );

    return ExcludeSemantics(
      child: Container(
        width: width,
        height: height,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(width >= 100 ? 4 : 3),
          boxShadow: const [
            BoxShadow(
              color: Color(0x2E26231E),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: book.coverUrl == null
            ? placeholder
            : Image.network(
                book.coverUrl.toString(),
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => placeholder,
              ),
      ),
    );
  }
}

ReadingSession _latestSession(List<ReadingSession> sessions) => sessions.reduce(
  (left, right) => left.startedAt.isAfter(right.startedAt) ? left : right,
);

class _ActiveSession extends StatelessWidget {
  const _ActiveSession({
    required this.session,
    required this.book,
    required this.repository,
    required this.busy,
    required this.onStart,
    required this.onStop,
    required this.onPhoto,
    required this.onVoice,
    required this.onRetryExtraction,
  });

  final ReadingSession? session;
  final PersonalBookSummary? book;
  final ReadingActivityRepository repository;
  final bool busy;
  final VoidCallback onStart;
  final VoidCallback onStop;
  final VoidCallback onPhoto;
  final VoidCallback onVoice;
  final Future<void> Function(String biteId) onRetryExtraction;

  @override
  Widget build(BuildContext context) {
    final s = BookBiteLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.readingSession), centerTitle: true),
      body: StreamBuilder<int>(
        stream: session == null
            ? const Stream<int>.empty()
            : Stream<int>.periodic(const Duration(seconds: 1), (tick) => tick),
        builder: (context, tick) {
          final elapsed = session == null
              ? Duration.zero
              : DateTime.now().toUtc().difference(session!.startedAt);
          return StreamBuilder<List<Bite>>(
            stream: session == null
                ? Stream.value(const <Bite>[])
                : repository.watchBitesForSession(session!.id),
            builder: (context, snapshot) {
              final bites = snapshot.data ?? const <Bite>[];
              return ListView(
                key: const PageStorageKey('active-reading-session'),
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 36),
                children: [
                  _SessionBookHeader(book: book),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 24),
                  Text(
                    'TIME READING',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      letterSpacing: 1.8,
                      color: BookBiteTokens.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _clock(elapsed),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'serif',
                      fontSize: 52,
                      height: 1,
                      color: BookBiteTokens.foreground,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _RoundControl(
                        tooltip: session == null
                            ? s.startSession
                            : 'Pause session',
                        icon: session == null
                            ? Icons.play_arrow_rounded
                            : Icons.pause_rounded,
                        onPressed: busy || session != null ? null : onStart,
                      ),
                      const SizedBox(width: 16),
                      _RoundControl(
                        tooltip: 'End session',
                        icon: Icons.stop_rounded,
                        foreground: const Color(0xFF7A3B32),
                        onPressed: busy ? null : onStop,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 20),
                  Text(
                    'CAPTURE A BITE',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      letterSpacing: 1.6,
                      color: BookBiteTokens.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: session == null ? null : onPhoto,
                          icon: const Icon(Icons.photo_camera_outlined),
                          label: Text(s.photo),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: session == null ? null : onVoice,
                          icon: const Icon(Icons.mic_none_outlined),
                          label: Text(s.voice),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'THIS SESSION · ${bites.length} '
                          '${bites.length == 1 ? 'BITE' : 'BITES'}',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                letterSpacing: 1.3,
                                color: BookBiteTokens.secondaryText,
                              ),
                        ),
                      ),
                      TextButton(
                        onPressed: bites.isEmpty
                            ? null
                            : () => SessionBitesRoute(
                                sessionId: session!.id,
                              ).push<void>(context),
                        child: const Text('See all'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (bites.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        s.noBitesYet,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    )
                  else
                    for (final bite in bites.take(2)) ...[
                      bites_ui.BiteCard(bite: bite, repository: repository),
                      const SizedBox(height: 10),
                    ],
                  if (session != null) ...[
                    const SizedBox(height: 12),
                    FilledButton(onPressed: onStop, child: Text(s.endSession)),
                  ],
                ],
              );
            },
          );
        },
      ),
    );
  }

  static String _clock(Duration value) =>
      '${value.inMinutes.toString().padLeft(2, '0')}:'
      '${value.inSeconds.remainder(60).toString().padLeft(2, '0')}';
}

class _SessionBookHeader extends StatelessWidget {
  const _SessionBookHeader({required this.book});
  final PersonalBookSummary? book;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 52,
        height: 72,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: BookBiteTokens.primary,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          (book?.title.isNotEmpty ?? false)
              ? book!.title.characters.first.toUpperCase()
              : 'B',
          style: const TextStyle(
            color: BookBiteTokens.surface,
            fontFamily: 'serif',
            fontSize: 22,
          ),
        ),
      ),
      const SizedBox(width: 14),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              book?.title ?? 'Reading without a book',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (book?.author != null) ...[
              const SizedBox(height: 3),
              Text(book!.author!),
            ],
          ],
        ),
      ),
    ],
  );
}

class _RoundControl extends StatelessWidget {
  const _RoundControl({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    this.foreground = BookBiteTokens.foreground,
  });
  final String tooltip;
  final IconData icon;
  final VoidCallback? onPressed;
  final Color foreground;

  @override
  Widget build(BuildContext context) => IconButton.outlined(
    onPressed: onPressed,
    tooltip: tooltip,
    color: foreground,
    icon: Icon(icon),
  );
}

class _BiteCard extends StatefulWidget {
  const _BiteCard({
    required this.bite,
    required this.repository,
    required this.onRetryExtraction,
  });

  final Bite bite;
  final ReadingActivityRepository repository;
  final Future<void> Function(String biteId) onRetryExtraction;

  @override
  State<_BiteCard> createState() => _BiteCardState();
}

class _BiteCardState extends State<_BiteCard> {
  late final TextEditingController _controller;
  bool _editing = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.bite.extractedText ?? '');
  }

  @override
  void didUpdateWidget(covariant _BiteCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_editing &&
        oldWidget.bite.extractedText != widget.bite.extractedText) {
      _controller.text = widget.bite.extractedText ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = BookBiteLocalizations.of(context);
    final (label, icon) = switch (widget.bite.extractionStatus) {
      ExtractionStatus.captured => (s.ocrQueued, Icons.hourglass_empty_rounded),
      ExtractionStatus.processing => (
        s.ocrProcessing,
        Icons.text_snippet_outlined,
      ),
      ExtractionStatus.ready => (s.ocrReady, Icons.check_circle_outline),
      ExtractionStatus.failed => (s.ocrFailed, Icons.error_outline_rounded),
    };
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                _SourcePreview(bite: widget.bite),
                const SizedBox(width: 12),
                Icon(icon, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(label)),
                if (widget.bite.extractionStatus == ExtractionStatus.ready)
                  IconButton(
                    onPressed: () => setState(() => _editing = !_editing),
                    tooltip: s.editText,
                    icon: Icon(
                      _editing ? Icons.close_rounded : Icons.edit_outlined,
                    ),
                  ),
              ],
            ),
            if (widget.bite.extractionStatus == ExtractionStatus.ready) ...[
              const SizedBox(height: 12),
              if (_editing) ...[
                TextField(
                  controller: _controller,
                  minLines: 3,
                  maxLines: 12,
                  decoration: InputDecoration(
                    labelText: s.extractedText,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: _saving ? null : _save,
                  child: Text(_saving ? s.savingShort : s.saveChanges),
                ),
              ] else
                SelectableText(
                  widget.bite.extractedText?.isNotEmpty == true
                      ? widget.bite.extractedText!
                      : s.noTextFound,
                ),
            ],
            if (widget.bite.extractionStatus == ExtractionStatus.failed)
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton.icon(
                  onPressed: () => widget.onRetryExtraction(widget.bite.id),
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(s.retryOcr),
                ),
              ),
            if (widget.bite.extractionStatus == ExtractionStatus.ready &&
                widget.bite.mediaReference != null)
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton.icon(
                  onPressed: _deleteSource,
                  icon: const Icon(Icons.delete_outline_rounded),
                  label: Text(s.deleteSource),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await widget.repository.updateBiteText(widget.bite.id, _controller.text);
    if (mounted) {
      setState(() {
        _saving = false;
        _editing = false;
      });
    }
  }

  Future<void> _deleteSource() async {
    final s = BookBiteLocalizations.of(context);
    await widget.repository.deleteBiteSource(widget.bite.id);
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(s.sourceDeleted)));
    }
  }
}

class _SourcePreview extends StatelessWidget {
  const _SourcePreview({required this.bite});
  final Bite bite;

  @override
  Widget build(BuildContext context) {
    if (bite.sourceKind == BiteSourceKind.pageImage &&
        bite.mediaReference != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.file(
          File(bite.mediaReference!),
          width: 44,
          height: 56,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => const SizedBox.square(
            dimension: 48,
            child: Icon(Icons.broken_image_outlined),
          ),
        ),
      );
    }
    return const SizedBox.square(
      dimension: 48,
      child: Icon(Icons.graphic_eq_rounded),
    );
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
