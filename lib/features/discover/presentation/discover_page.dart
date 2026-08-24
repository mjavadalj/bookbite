import 'package:bookbite/app/theme/bookbite_theme.dart';
import 'package:bookbite/app/navigation/app_router.dart';
import 'package:bookbite/core/presentation/localization/bookbite_localizations.dart';
import 'package:bookbite/features/discover/application/discover_controller.dart';
import 'package:bookbite/features/discover/domain/catalog_book.dart';
import 'package:bookbite/features/discover/domain/catalog_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiscoverPage extends ConsumerStatefulWidget {
  const DiscoverPage({super.key});

  @override
  ConsumerState<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends ConsumerState<DiscoverPage>
    with RestorationMixin {
  final _scrollController = ScrollController();
  final _railController = ScrollController();
  String? _loadedLanguage;
  late final RestorableDouble _scrollOffset = RestorableDouble(0);
  late final RestorableDouble _railOffset = RestorableDouble(0);

  @override
  String? get restorationId => 'discover_browse';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_scrollOffset, 'browse_scroll_offset');
    registerForRestoration(_railOffset, 'category_rail_offset');
    if (_scrollOffset.value > 0) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _scrollController.jumpTo(_scrollOffset.value),
      );
    }
    if (_railOffset.value > 0) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _railController.jumpTo(_railOffset.value),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final language = BookBiteLocalizations.of(context).locale.languageCode;
    if (_loadedLanguage != language) {
      _loadedLanguage = language;
      Future<void>.microtask(
        () => ref
            .read(discoverControllerProvider.notifier)
            .ensureRootLoaded(language),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      _scrollOffset.value = _scrollController.offset;
      if (_scrollController.position.extentAfter < 720) {
        ref.read(discoverControllerProvider.notifier).loadMoreBrowse();
      }
    });
    _railController.addListener(() {
      _railOffset.value = _railController.offset;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _railController.dispose();
    _scrollOffset.dispose();
    _railOffset.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = BookBiteLocalizations.of(context);
    final state = ref.watch(discoverControllerProvider);
    final controller = ref.read(discoverControllerProvider.notifier);
    final textTheme = Theme.of(context).textTheme;
    return Semantics(
      label: strings.discover,
      child: CustomScrollView(
        controller: _scrollController,
        restorationId: 'discover_scroll',
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    header: true,
                    child: Text(
                      strings.discover,
                      style: textTheme.headlineMedium?.copyWith(
                        fontFamily: 'serif',
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _SearchLauncher(
                    onPressed: () =>
                        const ActiveSearchRoute().push<void>(context),
                  ),
                  const SizedBox(height: 12),
                  _CategoryRail(controller: _railController),
                ],
              ),
            ),
          ),
          _WeeklyShelf(section: state.weekly, onRetry: controller.loadRoot),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Expanded(
                    child: Semantics(
                      header: true,
                      child: Text(
                        strings.browseCatalog,
                        style: textTheme.titleLarge?.copyWith(
                          fontFamily: 'serif',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  _PreviewButton(
                    label: strings.filter,
                    icon: Icons.tune_rounded,
                    onPressed: () => _availabilityFeedback(
                      context,
                      strings.filtersComingSoon,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _BrowseGrid(
            section: state.browse,
            onRetry: () => controller.loadRoot(strings.locale.languageCode),
            onOpen: (book) => _openCatalog(context, book, 'browse'),
          ),
          SliverToBoxAdapter(
            child: _Pagination(
              section: state.browse,
              onLoadMore: controller.loadMoreBrowse,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

class _SearchLauncher extends StatelessWidget {
  const _SearchLauncher({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final strings = BookBiteLocalizations.of(context);
    return Semantics(
      button: true,
      label: strings.searchCatalog,
      child: Material(
        color: BookBiteTokens.surface,
        borderRadius: BorderRadius.circular(BookBiteTokens.surfaceRadius),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(BookBiteTokens.surfaceRadius),
          child: Container(
            constraints: const BoxConstraints(minHeight: 52),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              border: Border.all(color: BookBiteTokens.border),
              borderRadius: BorderRadius.circular(BookBiteTokens.surfaceRadius),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.search_rounded,
                  size: 24,
                  color: BookBiteTokens.secondaryText,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    strings.searchCatalog,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: BookBiteTokens.secondaryText,
                    ),
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

class _CategoryRail extends StatelessWidget {
  const _CategoryRail({required this.controller});
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final strings = BookBiteLocalizations.of(context);
    final categories = [
      (strings.allCategory, true),
      (strings.philosophy, false),
      (strings.fiction, false),
      (strings.history, false),
      (strings.biography, false),
      (strings.selfHelp, false),
    ];
    return SizedBox(
      height: 44,
      child: ListView.separated(
        controller: controller,
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final (label, selected) = categories[index];
          return Semantics(
            button: true,
            selected: selected,
            label: selected ? label : '$label, ${strings.categoriesComingSoon}',
            child: Material(
              color: selected ? BookBiteTokens.primary : BookBiteTokens.surface,
              borderRadius: BorderRadius.circular(22),
              child: InkWell(
                onTap: selected
                    ? null
                    : () => _availabilityFeedback(
                        context,
                        strings.categoriesComingSoon,
                      ),
                borderRadius: BorderRadius.circular(22),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: selected
                        ? null
                        : Border.all(color: BookBiteTokens.border),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: selected
                          ? BookBiteTokens.surface
                          : BookBiteTokens.foreground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _WeeklyShelf extends StatelessWidget {
  const _WeeklyShelf({required this.section, required this.onRetry});
  final CatalogSection section;
  final Future<void> Function(String) onRetry;

  @override
  Widget build(BuildContext context) {
    final strings = BookBiteLocalizations.of(context);
    if (section.status == CatalogStatus.empty) {
      return const SliverToBoxAdapter();
    }
    return SliverPadding(
      padding: const EdgeInsets.only(top: 8),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Semantics(
                header: true,
                child: Text(
                  strings.exploreThisWeek,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontFamily: 'serif',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (section.status == CatalogStatus.loading)
              const SizedBox(
                height: 260,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (section.status == CatalogStatus.error ||
                section.status == CatalogStatus.offline)
              _CatalogMessage(
                section: section,
                onRetry: () => onRetry(strings.locale.languageCode),
              )
            else
              SizedBox(
                height: _weeklyShelfHeight(context),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: section.books.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final book = section.books[index];
                    return SizedBox(
                      width: 124,
                      child: _BookTile(
                        book: book,
                        onTap: () => _openCatalog(context, book, 'weekly'),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BrowseGrid extends StatelessWidget {
  const _BrowseGrid({
    required this.section,
    required this.onRetry,
    required this.onOpen,
  });
  final CatalogSection section;
  final VoidCallback onRetry;
  final ValueChanged<CatalogBook> onOpen;
  @override
  Widget build(BuildContext context) {
    if (section.status == CatalogStatus.loading && section.books.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(48),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    if (section.status == CatalogStatus.error ||
        section.status == CatalogStatus.offline) {
      return SliverToBoxAdapter(
        child: _CatalogMessage(section: section, onRetry: onRetry),
      );
    }
    if (section.status == CatalogStatus.empty) {
      return SliverToBoxAdapter(
        child: _CatalogMessage(section: section, onRetry: onRetry),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      sliver: SliverLayoutBuilder(
        builder: (context, constraints) {
          final textScale = MediaQuery.textScalerOf(
            context,
          ).scale(1).clamp(1.0, 2.0);
          final columns = constraints.crossAxisExtent >= 720
              ? (constraints.crossAxisExtent / 132).floor().clamp(4, 6)
              : 3;
          const spacing = 12.0;
          final tileWidth =
              (constraints.crossAxisExtent - spacing * (columns - 1)) / columns;
          return SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _BookTile(
                book: section.books[index],
                onTap: () => onOpen(section.books[index]),
              ),
              childCount: section.books.length,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisSpacing: 16,
              crossAxisSpacing: spacing,
              mainAxisExtent: tileWidth * 1.5 + 62 * textScale,
            ),
          );
        },
      ),
    );
  }
}

class _BookTile extends StatelessWidget {
  const _BookTile({required this.book, required this.onTap});
  final CatalogBook book;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final strings = BookBiteLocalizations.of(context);
    final authors = book.authors.join(', ');
    return Semantics(
      button: true,
      label: '${book.title}, $authors, ${strings.catalogResults}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(BookBiteTokens.controlRadius),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Cover(book: book),
              const SizedBox(height: 6),
              Directionality(
                textDirection: _contentDirection(book.title),
                child: Text(
                  book.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: BookBiteTokens.foreground,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Directionality(
                textDirection: _contentDirection(authors),
                child: Text(
                  authors,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontSize: 13, height: 1.25),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Cover extends StatelessWidget {
  const _Cover({required this.book});
  final CatalogBook book;
  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: 2 / 3,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(BookBiteTokens.controlRadius),
      child: book.coverUrl == null
          ? _CoverPlaceholder(title: book.title)
          : Image.network(
              book.coverUrl.toString(),
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _CoverPlaceholder(title: book.title),
            ),
    ),
  );
}

class _CoverPlaceholder extends StatelessWidget {
  const _CoverPlaceholder({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Container(
      color: BookBiteTokens.softSurface,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(12),
      child: Icon(
        Icons.menu_book_outlined,
        color: BookBiteTokens.atmosphericSage,
        size: 36,
      ),
    ),
  );
}

class _CatalogMessage extends StatelessWidget {
  const _CatalogMessage({required this.section, required this.onRetry});
  final CatalogSection section;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) {
    final strings = BookBiteLocalizations.of(context);
    final offline =
        section.status == CatalogStatus.offline ||
        section.failure?.kind == CatalogFailureKind.offline;
    final empty = section.status == CatalogStatus.empty;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            empty
                ? strings.browseEmpty
                : (offline
                      ? strings.liveSearchNeedsConnection
                      : strings.catalogUnavailable),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: Text(strings.retry),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () =>
                const ManualBookDestinationRoute().push<void>(context),
            icon: const Icon(Icons.auto_stories_outlined),
            label: Text(strings.manualCreateTitle),
          ),
        ],
      ),
    );
  }
}

class _Pagination extends StatelessWidget {
  const _Pagination({required this.section, required this.onLoadMore});
  final CatalogSection section;
  final Future<void> Function() onLoadMore;
  @override
  Widget build(BuildContext context) {
    final strings = BookBiteLocalizations.of(context);
    if (section.books.isEmpty) return const SizedBox.shrink();
    if (section.failure != null && section.hasMore) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: OutlinedButton(
          onPressed: onLoadMore,
          child: Text(strings.retry),
        ),
      );
    }
    if (section.hasMore) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: OutlinedButton(
          onPressed: onLoadMore,
          child: Text(strings.loadMoreBooks),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Text(
        strings.endOfCatalog,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

class _PreviewButton extends StatelessWidget {
  const _PreviewButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => TextButton.icon(
    onPressed: onPressed,
    icon: Icon(icon),
    label: Text(label),
  );
}

void _availabilityFeedback(BuildContext context, String message) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
  );
  SemanticsService.sendAnnouncement(
    View.of(context),
    message,
    Directionality.of(context),
  );
}

void _openCatalog(BuildContext context, CatalogBook book, String origin) =>
    CatalogBookDestinationRoute(
      provider: book.provider,
      id: book.id,
      origin: origin,
    ).push<void>(context);

TextDirection _contentDirection(String text) =>
    RegExp(r'[\u0600-\u06FF]').hasMatch(text)
    ? TextDirection.rtl
    : TextDirection.ltr;

double _weeklyShelfHeight(BuildContext context) {
  final textScale = MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 2.0);
  return 186 + 62 * textScale;
}
