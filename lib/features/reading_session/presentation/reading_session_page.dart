import 'dart:async';
import 'dart:io';

import 'package:bookbite/app/navigation/app_router.dart';
import 'package:bookbite/app/theme/bookbite_theme.dart';
import 'package:bookbite/core/presentation/localization/bookbite_localizations.dart';
import 'package:bookbite/core/presentation/widgets/foundation_page.dart';
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
  String _query = '';
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
                onPhoto: _capturePhoto,
                onVoice: _captureVoice,
                onRetryExtraction: _retryExtraction,
                onEnd: () => _confirmEnd(repository),
              );
            },
          );
        }
        if (_selected != null) {
          return _BookConfirmation(
            book: _selected!,
            busy: _busy,
            onStart: () => _start(_selected!.id),
            onBack: () => setState(() => _selected = null),
          );
        }
        return StreamBuilder<List<PersonalBookSummary>>(
          stream: ref.watch(personalBookRepositoryProvider).watchActiveBooks(),
          builder: (context, snapshot) {
            final query = _query.trim().toLowerCase();
            final books = (snapshot.data ?? const <PersonalBookSummary>[])
                .where(
                  (book) =>
                      query.isEmpty ||
                      book.title.toLowerCase().contains(query) ||
                      (book.author?.toLowerCase().contains(query) ?? false),
                )
                .toList(growable: false);
            return _IdleSession(
              books: books,
              loading: snapshot.connectionState == ConnectionState.waiting,
              busy: _busy,
              onQueryChanged: (value) => setState(() => _query = value),
              onSelect: (book) => setState(() => _selected = book),
              onStartWithoutBook: () => _start(null),
              onPhoto: _capturePhoto,
              onVoice: _captureVoice,
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
    required this.loading,
    required this.busy,
    required this.onQueryChanged,
    required this.onSelect,
    required this.onStartWithoutBook,
    required this.onPhoto,
    required this.onVoice,
  });

  final List<PersonalBookSummary> books;
  final bool loading;
  final bool busy;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<PersonalBookSummary> onSelect;
  final VoidCallback onStartWithoutBook;
  final VoidCallback onPhoto;
  final VoidCallback onVoice;

  @override
  Widget build(BuildContext context) {
    final s = BookBiteLocalizations.of(context);
    return FoundationPage(
      title: s.welcome,
      message: s.chooseBook,
      action: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: s.searchLibrary,
              prefixIcon: const Icon(Icons.search_rounded),
              border: const OutlineInputBorder(),
            ),
            onChanged: onQueryChanged,
          ),
          const SizedBox(height: 16),
          Text(s.yourLibrary, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (loading)
            const Center(child: CircularProgressIndicator())
          else if (books.isEmpty)
            Text(s.noLibraryBooks)
          else
            ...books.map(
              (book) => Card(
                child: ListTile(
                  minVerticalPadding: 12,
                  title: Text(book.title),
                  subtitle: Text(book.author ?? s.authorUnavailable),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => onSelect(book),
                ),
              ),
            ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: busy ? null : onStartWithoutBook,
            child: Text(s.startWithoutBook),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onPhoto,
                  icon: const Icon(Icons.photo_camera_outlined),
                  label: Text(s.photo),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onVoice,
                  icon: const Icon(Icons.mic_none_outlined),
                  label: Text(s.voice),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BookConfirmation extends StatelessWidget {
  const _BookConfirmation({
    required this.book,
    required this.busy,
    required this.onStart,
    required this.onBack,
  });

  final PersonalBookSummary book;
  final bool busy;
  final VoidCallback onStart;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final s = BookBiteLocalizations.of(context);
    return FoundationPage(
      title: s.confirmBook,
      message: book.title,
      action: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(book.author ?? s.authorUnavailable),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: busy ? null : onStart,
            child: busy
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(s.beginReading),
          ),
          const SizedBox(height: 8),
          OutlinedButton(onPressed: busy ? null : onBack, child: Text(s.back)),
        ],
      ),
    );
  }
}

class _ActiveSession extends StatelessWidget {
  const _ActiveSession({
    required this.session,
    required this.book,
    required this.repository,
    required this.onPhoto,
    required this.onVoice,
    required this.onRetryExtraction,
    required this.onEnd,
  });

  final ReadingSession session;
  final PersonalBookSummary? book;
  final ReadingActivityRepository repository;
  final VoidCallback onPhoto;
  final VoidCallback onVoice;
  final Future<void> Function(String biteId) onRetryExtraction;
  final VoidCallback onEnd;

  @override
  Widget build(BuildContext context) {
    final s = BookBiteLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.readingSession), centerTitle: true),
      body: StreamBuilder<int>(
        stream: Stream<int>.periodic(
          const Duration(seconds: 1),
          (tick) => tick,
        ),
        builder: (context, tick) {
          final elapsed = DateTime.now().toUtc().difference(session.startedAt);
          return StreamBuilder<List<Bite>>(
            stream: repository.watchBitesForSession(session.id),
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
                        tooltip: 'Pause session',
                        icon: Icons.pause_rounded,
                        onPressed: () {},
                      ),
                      const SizedBox(width: 16),
                      _RoundControl(
                        tooltip: 'End session',
                        icon: Icons.stop_rounded,
                        foreground: const Color(0xFF7A3B32),
                        onPressed: onEnd,
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
                          onPressed: onPhoto,
                          icon: const Icon(Icons.photo_camera_outlined),
                          label: Text(s.photo),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onVoice,
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
                                sessionId: session.id,
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
                  const SizedBox(height: 12),
                  FilledButton(onPressed: onEnd, child: Text(s.endSession)),
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
  final VoidCallback onPressed;
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
