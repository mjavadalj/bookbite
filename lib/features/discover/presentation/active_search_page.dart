import 'package:bookbite/app/theme/bookbite_theme.dart';
import 'package:bookbite/app/navigation/app_router.dart';
import 'package:bookbite/core/presentation/localization/bookbite_localizations.dart';
import 'package:bookbite/features/discover/application/discover_controller.dart';
import 'package:bookbite/features/discover/domain/catalog_book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ActiveSearchPage extends ConsumerStatefulWidget {
  const ActiveSearchPage({this.initialQuery, super.key});
  final String? initialQuery;
  @override
  ConsumerState<ActiveSearchPage> createState() => _ActiveSearchPageState();
}

class _ActiveSearchPageState extends ConsumerState<ActiveSearchPage>
    with RestorationMixin {
  final _input = TextEditingController();
  final _focus = FocusNode();
  final _scroll = ScrollController();
  final _restoredQuery = RestorableString('');

  @override
  String? get restorationId => 'discover_active_search_state';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_restoredQuery, 'query');
    if (widget.initialQuery == null && _restoredQuery.value.isNotEmpty) {
      _input.text = _restoredQuery.value;
    }
  }

  @override
  void initState() {
    super.initState();
    _input.text = widget.initialQuery ?? '';
    _input.addListener(() => _restoredQuery.value = _input.text);
    _scroll.addListener(() {
      if (_scroll.position.extentAfter < 600)
        ref.read(discoverControllerProvider.notifier).loadMoreSearch();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(discoverControllerProvider.notifier)
          .setLanguage(BookBiteLocalizations.of(context).locale.languageCode);
      _focus.requestFocus();
      if (_input.text.isNotEmpty)
        ref.read(discoverControllerProvider.notifier).updateSearch(_input.text);
    });
  }

  @override
  void dispose() {
    _input.dispose();
    _focus.dispose();
    _scroll.dispose();
    _restoredQuery.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = BookBiteLocalizations.of(context);
    final state = ref.watch(discoverControllerProvider);
    final controller = ref.read(discoverControllerProvider.notifier);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _input,
                      focusNode: _focus,
                      autofocus: true,
                      textInputAction: TextInputAction.search,
                      onChanged: controller.updateSearch,
                      onSubmitted: (_) => controller.submitSearch(),
                      decoration: InputDecoration(
                        hintText: strings.searchCatalog,
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: state.visibleQuery.isEmpty
                            ? null
                            : IconButton(
                                tooltip: strings.clear,
                                onPressed: () {
                                  _input.clear();
                                  controller.clearSearch();
                                  _focus.requestFocus();
                                },
                                icon: const Icon(Icons.close_rounded),
                              ),
                        errorText: state.queryError == 'tooLong'
                            ? strings.searchTooLong
                            : null,
                        filled: true,
                        fillColor: BookBiteTokens.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            BookBiteTokens.surfaceRadius,
                          ),
                          borderSide: const BorderSide(
                            color: BookBiteTokens.border,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            BookBiteTokens.surfaceRadius,
                          ),
                          borderSide: const BorderSide(
                            color: BookBiteTokens.border,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            BookBiteTokens.surfaceRadius,
                          ),
                          borderSide: const BorderSide(
                            color: BookBiteTokens.primary,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: context.pop,
                    child: Text(strings.cancel),
                  ),
                ],
              ),
            ),
            if (state.pendingQuery case final pending?)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    strings.pendingSearch.replaceFirst('{query}', pending),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            Expanded(
              child: _SearchResults(
                controller: _scroll,
                section: state.search,
                query: state.submittedQuery,
                pending: state.pendingQuery,
                onOpen: (book) => CatalogBookDestinationRoute(
                  provider: book.provider,
                  id: book.id,
                  origin: 'search',
                ).push<void>(context),
                onManual: () => ManualBookDestinationRoute(
                  query: state.visibleQuery.trim(),
                ).push<void>(context),
                onRetry: controller.submitSearch,
                onLoadMore: controller.loadMoreSearch,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({
    required this.controller,
    required this.section,
    required this.query,
    required this.pending,
    required this.onOpen,
    required this.onManual,
    required this.onRetry,
    required this.onLoadMore,
  });
  final ScrollController controller;
  final CatalogSection section;
  final String query;
  final String? pending;
  final ValueChanged<CatalogBook> onOpen;
  final VoidCallback onManual;
  final VoidCallback onRetry;
  final Future<void> Function() onLoadMore;
  @override
  Widget build(BuildContext context) {
    final strings = BookBiteLocalizations.of(context);
    if (query.isEmpty && pending == null)
      return _SearchMessage(
        message: strings.searchGuidance,
        onManual: onManual,
      );
    if (pending != null && query.isEmpty) {
      final message = pending!.runes.length < 3
          ? strings.typeMoreToSearch
          : strings.pendingSearch.replaceFirst('{query}', pending!);
      return _SearchMessage(message: message, onManual: onManual);
    }
    if (section.status == CatalogStatus.loading && section.books.isEmpty)
      return const Center(child: CircularProgressIndicator());
    if (section.status == CatalogStatus.empty)
      return _SearchMessage(
        message: strings.noMatches.replaceFirst('{query}', query),
        onManual: onManual,
      );
    if ((section.status == CatalogStatus.error ||
            section.status == CatalogStatus.offline) &&
        section.books.isEmpty)
      return _SearchMessage(
        message: section.status == CatalogStatus.offline
            ? strings.liveSearchNeedsConnection
            : strings.catalogUnavailable,
        onManual: onManual,
        onRetry: onRetry,
      );
    return ListView.separated(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      itemCount: section.books.length + 2,
      separatorBuilder: (_, _) => const Divider(color: BookBiteTokens.border),
      itemBuilder: (context, index) {
        if (index == 0)
          return Text(
            section.hasSavedContent
                ? strings.savedCatalog
                : (section.total == null
                      ? strings.catalogResults
                      : '${section.total} ${strings.catalogResults}'),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: BookBiteTokens.secondaryText,
            ),
          );
        if (index == section.books.length + 1)
          return Column(
            children: [
              const SizedBox(height: 16),
              _ManualEntry(onTap: onManual),
              if (section.hasMore)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: OutlinedButton(
                    onPressed: onLoadMore,
                    child: Text(strings.loadMoreBooks),
                  ),
                ),
            ],
          );
        return _SearchRow(
          book: section.books[index - 1],
          query: query,
          onTap: () => onOpen(section.books[index - 1]),
        );
      },
    );
  }
}

class _SearchRow extends StatelessWidget {
  const _SearchRow({
    required this.book,
    required this.query,
    required this.onTap,
  });
  final CatalogBook book;
  final String query;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final strings = BookBiteLocalizations.of(context);
    final author = book.authors.isEmpty
        ? strings.authorUnavailable
        : book.authors.join(', ');
    return Semantics(
      button: true,
      label: '${book.title}, $author',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(BookBiteTokens.controlRadius),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              SizedBox(
                width: 80,
                child: AspectRatio(
                  aspectRatio: 2 / 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: book.coverUrl == null
                        ? _searchCoverPlaceholder()
                        : Image.network(
                            book.coverUrl.toString(),
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                _searchCoverPlaceholder(),
                          ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _EmphasizedText(
                      text: book.title,
                      query: query,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      author,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: BookBiteTokens.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_rounded,
                color: BookBiteTokens.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _searchCoverPlaceholder() => Container(
  color: BookBiteTokens.softSurface,
  child: const ExcludeSemantics(child: Icon(Icons.menu_book_outlined)),
);

class _EmphasizedText extends StatelessWidget {
  const _EmphasizedText({required this.text, required this.query, this.style});
  final String text;
  final String query;
  final TextStyle? style;
  @override
  Widget build(BuildContext context) {
    final start = text.toLowerCase().indexOf(query.toLowerCase());
    if (start < 0 || query.isEmpty) return Text(text, style: style);
    final end = start + query.length;
    return Text.rich(
      TextSpan(
        style: style,
        children: [
          TextSpan(text: text.substring(0, start)),
          TextSpan(
            text: text.substring(start, end),
            style: style?.copyWith(
              fontWeight: FontWeight.w800,
              decoration: TextDecoration.underline,
            ),
          ),
          TextSpan(text: text.substring(end)),
        ],
      ),
    );
  }
}

class _SearchMessage extends StatelessWidget {
  const _SearchMessage({
    required this.message,
    required this.onManual,
    this.onRetry,
  });
  final String message;
  final VoidCallback onManual;
  final VoidCallback? onRetry;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: onRetry,
              child: Text(BookBiteLocalizations.of(context).retry),
            ),
          ],
          const SizedBox(height: 20),
          _ManualEntry(onTap: onManual),
        ],
      ),
    ),
  );
}

class _ManualEntry extends StatelessWidget {
  const _ManualEntry({required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final s = BookBiteLocalizations.of(context);
    return Semantics(
      button: true,
      label: '${s.manualCreateTitle}. ${s.manualCreateDescription}',
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.all(16),
          alignment: AlignmentDirectional.centerStart,
        ),
        onPressed: onTap,
        icon: const Icon(Icons.auto_stories_outlined, size: 30),
        label: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              s.manualCreateTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              s.manualCreateDescription,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
