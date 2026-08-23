import 'dart:io';

import 'package:bookbite/app/theme/bookbite_theme.dart';
import 'package:bookbite/features/reading_session/application/reading_activity_providers.dart';
import 'package:bookbite/features/reading_session/domain/reading_activity.dart';
import 'package:bookbite/features/reading_session/domain/reading_activity_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

enum BiteCollectionKind { book, session }

class BiteCollectionPage extends ConsumerStatefulWidget {
  const BiteCollectionPage({
    required this.kind,
    required this.ownerId,
    this.title,
    super.key,
  });

  final BiteCollectionKind kind;
  final String ownerId;
  final String? title;

  @override
  ConsumerState<BiteCollectionPage> createState() => _BiteCollectionPageState();
}

class _BiteCollectionPageState extends ConsumerState<BiteCollectionPage> {
  String _query = '';
  BiteTag? _tag;

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(readingActivityRepositoryProvider);
    final stream = switch (widget.kind) {
      BiteCollectionKind.book => repository.watchBitesForBook(widget.ownerId),
      BiteCollectionKind.session => repository.watchBitesForSession(
        widget.ownerId,
      ),
    };
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title ??
              (widget.kind == BiteCollectionKind.book
                  ? 'Bites'
                  : 'Saved in Session'),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Bite>>(
        stream: stream,
        builder: (context, snapshot) {
          final all = snapshot.data ?? const <Bite>[];
          final query = _query.trim().toLowerCase();
          final visible = all
              .where((bite) {
                final matchesText =
                    query.isEmpty ||
                    (bite.extractedText ?? '').toLowerCase().contains(query);
                final matchesTag = _tag == null || bite.tags.contains(_tag);
                return matchesText && matchesTag;
              })
              .toList(growable: false);
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (widget.kind == BiteCollectionKind.session) ...[
                        Text(
                          'All your bites in one place',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                      ],
                      TextField(
                        onChanged: (value) => setState(() => _query = value),
                        decoration: const InputDecoration(
                          labelText: 'Search bites',
                          hintText: 'Search words in your notes',
                          prefixIcon: Icon(Icons.search_rounded),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _FilterChip(
                              label: 'All ${all.length}',
                              selected: _tag == null,
                              onSelected: () => setState(() => _tag = null),
                            ),
                            for (final tag in BiteTag.values) ...[
                              const SizedBox(width: 8),
                              _FilterChip(
                                label:
                                    '${tag.label} ${all.where((bite) => bite.tags.contains(tag)).length}',
                                selected: _tag == tag,
                                onSelected: () => setState(() => _tag = tag),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (snapshot.connectionState == ConnectionState.waiting &&
                  !snapshot.hasData)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (visible.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        all.isEmpty
                            ? 'No bites saved here yet.'
                            : 'No bites match this search.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  sliver: SliverList.separated(
                    itemCount: visible.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) =>
                        BiteCard(bite: visible[index], repository: repository),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) => ChoiceChip(
    label: Text(label),
    selected: selected,
    onSelected: (_) => onSelected(),
    showCheckmark: false,
    visualDensity: VisualDensity.compact,
  );
}

class BiteCard extends StatelessWidget {
  const BiteCard({required this.bite, required this.repository, super.key});

  final Bite bite;
  final ReadingActivityRepository repository;

  @override
  Widget build(BuildContext context) {
    final text = bite.extractedText?.trim();
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 8, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SourceThumbnail(bite: bite),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text?.isNotEmpty == true ? text! : _statusLabel(bite),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontFamily: 'serif',
                      height: 1.4,
                    ),
                  ),
                  if (bite.tags.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: bite.tags
                          .map(
                            (tag) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: BookBiteTokens.selectedSurface,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                tag.label,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          )
                          .toList(growable: false),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    DateFormat(
                      'MMM d · HH:mm',
                    ).format(bite.createdAt.toLocal()),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => showBiteEditor(context, bite, repository),
              tooltip: 'Edit text',
              icon: const Icon(Icons.edit_outlined),
            ),
          ],
        ),
      ),
    );
  }

  String _statusLabel(Bite bite) => switch (bite.extractionStatus) {
    ExtractionStatus.captured => 'Waiting to extract text…',
    ExtractionStatus.processing => 'Extracting text…',
    ExtractionStatus.ready => 'No text found',
    ExtractionStatus.failed => 'Text extraction failed',
  };
}

class _SourceThumbnail extends StatelessWidget {
  const _SourceThumbnail({required this.bite});
  final Bite bite;

  @override
  Widget build(BuildContext context) {
    if (bite.sourceKind == BiteSourceKind.pageImage &&
        bite.mediaReference != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(bite.mediaReference!),
          width: 42,
          height: 56,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _fallback(),
        ),
      );
    }
    return _fallback();
  }

  Widget _fallback() => Container(
    width: 42,
    height: 42,
    decoration: const BoxDecoration(
      color: BookBiteTokens.selectedSurface,
      shape: BoxShape.circle,
    ),
    child: Icon(
      bite.sourceKind == BiteSourceKind.pageImage
          ? Icons.photo_outlined
          : Icons.mic_none_rounded,
      size: 20,
      color: BookBiteTokens.primary,
    ),
  );
}

Future<void> showBiteEditor(
  BuildContext context,
  Bite bite,
  ReadingActivityRepository repository,
) async {
  final text = TextEditingController(text: bite.extractedText ?? '');
  final tags = bite.tags.toSet();
  var saving = false;
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => StatefulBuilder(
      builder: (context, setModalState) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.viewInsetsOf(context).bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Edit bite', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              TextField(
                controller: text,
                autofocus: true,
                minLines: 4,
                maxLines: 10,
                decoration: const InputDecoration(
                  labelText: 'Bite text',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Text('Tags', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: BiteTag.values
                    .map(
                      (tag) => FilterChip(
                        label: Text(tag.label),
                        selected: tags.contains(tag),
                        onSelected: (selected) => setModalState(() {
                          selected ? tags.add(tag) : tags.remove(tag);
                        }),
                      ),
                    )
                    .toList(growable: false),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: saving
                    ? null
                    : () async {
                        setModalState(() => saving = true);
                        await repository.updateBite(
                          biteId: bite.id,
                          text: text.text,
                          tags: tags,
                        );
                        if (context.mounted) Navigator.pop(context);
                      },
                child: Text(saving ? 'Saving…' : 'Save changes'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  // The modal route's reverse animation can still reference the controller
  // for a frame after its result completes.
  await Future<void>.delayed(const Duration(milliseconds: 300));
  text.dispose();
}
