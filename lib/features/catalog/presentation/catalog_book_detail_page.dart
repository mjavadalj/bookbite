import 'package:bookbite/app/navigation/app_router.dart';
import 'package:bookbite/app/theme/bookbite_theme.dart';
import 'package:bookbite/core/presentation/localization/bookbite_localizations.dart';
import 'package:bookbite/features/catalog/application/catalog_book_detail_controller.dart';
import 'package:bookbite/features/discover/domain/catalog_book.dart';
import 'package:bookbite/features/discover/domain/catalog_book_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CatalogBookDetailPage extends ConsumerStatefulWidget {
  const CatalogBookDetailPage({
    required this.provider,
    required this.bookId,
    this.origin,
    super.key,
  });
  final String provider;
  final String bookId;
  final String? origin;

  @override
  ConsumerState<CatalogBookDetailPage> createState() =>
      _CatalogBookDetailPageState();
}

class _CatalogBookDetailPageState extends ConsumerState<CatalogBookDetailPage>
    with RestorationMixin {
  final _scroll = ScrollController();
  final _bodyAddKey = GlobalKey();
  late final RestorableDouble _offset = RestorableDouble(0);
  String? _language;
  bool _collapsed = false;

  @override
  String? get restorationId =>
      'catalog_detail_${widget.provider}_${widget.bookId}';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_offset, 'scroll_offset');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.jumpTo(
          _offset.value.clamp(0, _scroll.position.maxScrollExtent),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      _offset.value = _scroll.offset;
      final render = _bodyAddKey.currentContext?.findRenderObject();
      final bottom = render is RenderBox
          ? render.localToGlobal(Offset.zero).dy + render.size.height
          : double.infinity;
      final value = bottom <= MediaQuery.of(context).padding.top + 8;
      if (value != _collapsed && mounted) setState(() => _collapsed = value);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final language = BookBiteLocalizations.of(context).locale.languageCode;
    if (_language == language) return;
    _language = language;
    Future<void>.microtask(
      () => ref
          .read(
            catalogBookDetailControllerProvider(
              widget.provider,
              widget.bookId,
              widget.origin,
            ).notifier,
          )
          .load(language),
    );
  }

  @override
  void dispose() {
    _scroll.dispose();
    _offset.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = BookBiteLocalizations.of(context);
    final provider = catalogBookDetailControllerProvider(
      widget.provider,
      widget.bookId,
      widget.origin,
    );
    final state = ref.watch(provider);
    void retry() =>
        ref.read(provider.notifier).retry(strings.locale.languageCode);
    void addToLibrary() => ref.read(provider.notifier).addToLibrary();
    if (!state.hasContent) return _StateView(state: state, retry: retry);

    final detail = state.detail!;
    return Scaffold(
      backgroundColor: BookBiteTokens.canvas,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scroll,
            slivers: [
              SliverToBoxAdapter(
                child: _Hero(
                  detail: detail,
                  addKey: _bodyAddKey,
                  saveStatus: state.saveStatus,
                  onAdd: addToLibrary,
                ),
              ),
              if (state.fromCache ||
                  state.detailStatus == CatalogDetailStatus.refreshing ||
                  state.failure != null)
                SliverToBoxAdapter(
                  child: _CacheStatus(state: state, onRetry: retry),
                ),
              SliverToBoxAdapter(
                child: _Section(
                  title: strings.aboutThisBook,
                  child: detail.description == null
                      ? null
                      : Directionality(
                          textDirection: _direction(detail.description!),
                          child: Text(
                            detail.description!,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                ),
              ),
              SliverToBoxAdapter(child: _Details(detail: detail)),
              if (state.relatedStatus == CatalogRelatedStatus.loading)
                SliverToBoxAdapter(child: _RelatedLoading()),
              if (state.related.isNotEmpty)
                SliverToBoxAdapter(
                  child: _Related(
                    books: state.related,
                    onOpen: (book) => CatalogBookDestinationRoute(
                      provider: book.provider,
                      id: book.id,
                    ).push<void>(context),
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 48)),
            ],
          ),
          _PinnedHeader(
            visible: _collapsed,
            detail: detail,
            saveStatus: state.saveStatus,
            onAdd: addToLibrary,
          ),
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({
    required this.detail,
    required this.addKey,
    required this.saveStatus,
    required this.onAdd,
  });
  final CatalogBookDetail detail;
  final Key addKey;
  final PersonalBookSaveStatus saveStatus;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final strings = BookBiteLocalizations.of(context);
    final authors = detail.authors.isEmpty
        ? strings.authorUnavailable
        : detail.authors.join(', ');
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: IconButton(
                tooltip: strings.back,
                onPressed: context.pop,
                icon: const Icon(Icons.arrow_back_rounded),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 210,
              child: _Cover(
                url: detail.coverUrl,
                label: detail.title,
                large: true,
              ),
            ),
            const SizedBox(height: 24),
            Directionality(
              textDirection: _direction(detail.title),
              child: Text(
                detail.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const SizedBox(height: 8),
            Directionality(
              textDirection: _direction(authors),
              child: Text(
                authors,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: BookBiteTokens.secondaryText,
                ),
              ),
            ),
            if (detail.subjects.isNotEmpty) ...[
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                children: detail.subjects
                    .take(3)
                    .map(
                      (subject) => Chip(
                        label: Text(subject),
                        backgroundColor: BookBiteTokens.softSurface,
                        side: const BorderSide(color: BookBiteTokens.border),
                      ),
                    )
                    .toList(),
              ),
            ],
            if (detail.description != null) ...[
              const SizedBox(height: 16),
              Directionality(
                textDirection: _direction(detail.description!),
                child: Text(
                  detail.description!,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: _AddToLibraryButton(
                key: addKey,
                status: saveStatus,
                onPressed: onAdd,
              ),
            ),
            const SizedBox(height: 12),
            Semantics(
              liveRegion: true,
              child: Text(
                _saveHelper(strings, saveStatus),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: saveStatus == PersonalBookSaveStatus.failure
                      ? Theme.of(context).colorScheme.error
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(height: 1, color: BookBiteTokens.border),
          ],
        ),
      ),
    );
  }
}

class _CacheStatus extends StatelessWidget {
  const _CacheStatus({required this.state, required this.onRetry});
  final CatalogBookDetailState state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final strings = BookBiteLocalizations.of(context);
    final failure = state.failure != null;
    final offline = state.isOffline;
    final label = failure
        ? (offline ? strings.connectionNeeded : strings.catalogUnavailable)
        : (state.detailStatus == CatalogDetailStatus.refreshing
              ? strings.refreshingCatalog
              : strings.offlineCatalogCopy);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
      child: Row(
        children: [
          Icon(
            failure ? Icons.cloud_off_outlined : Icons.cloud_done_outlined,
            size: 18,
            color: BookBiteTokens.secondaryText,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          if (failure)
            TextButton(onPressed: onRetry, child: Text(strings.retry)),
        ],
      ),
    );
  }
}

class _RelatedLoading extends StatelessWidget {
  const _RelatedLoading();

  @override
  Widget build(BuildContext context) {
    final strings = BookBiteLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.relatedCatalogBooks,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 188,
            child: Row(
              children: List<Widget>.generate(
                3,
                (index) => Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(
                      end: index == 2 ? 0 : 16,
                    ),
                    child: Container(
                      height: 188,
                      decoration: BoxDecoration(
                        color: BookBiteTokens.softSurface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: BookBiteTokens.border),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});
  final String title;
  final Widget? child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        if (child != null) ...[const SizedBox(height: 12), child!],
      ],
    ),
  );
}

class _Details extends StatelessWidget {
  const _Details({required this.detail});
  final CatalogBookDetail detail;

  @override
  Widget build(BuildContext context) {
    final s = BookBiteLocalizations.of(context);
    final rows = <(String, String)>[
      if (detail.authors.isNotEmpty) (s.authorLabel, detail.authors.join(', ')),
      if (detail.publicationDate != null)
        (s.publicationDate, detail.publicationDate!),
      if (detail.firstPublishedYear != null)
        (s.firstPublished, detail.firstPublishedYear.toString()),
      if (detail.edition != null) (s.edition, detail.edition!),
      if (detail.language != null) (s.languageLabel, detail.language!),
      if (detail.originalLanguage != null)
        (s.originalLanguage, detail.originalLanguage!),
      if (detail.pageCount != null) (s.pageCount, detail.pageCount.toString()),
      if (detail.isbn13.isNotEmpty) (s.isbn13, detail.isbn13.join(', ')),
      if (detail.isbn10.isNotEmpty) (s.isbn10, detail.isbn10.join(', ')),
    ];
    if (rows.isEmpty) return const SizedBox.shrink();
    return _Section(
      title: s.details,
      child: Column(
        children: rows
            .map(
              (row) => Semantics(
                label: '${row.$1}, ${row.$2}',
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          row.$1,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: Text(
                          row.$2,
                          textAlign: TextAlign.end,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _Related extends StatefulWidget {
  const _Related({required this.books, required this.onOpen});
  final List<CatalogBook> books;
  final ValueChanged<CatalogBook> onOpen;

  @override
  State<_Related> createState() => _RelatedState();
}

class _RelatedState extends State<_Related> {
  final _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _move(double delta) {
    if (!_controller.hasClients) return;
    _controller.animateTo(
      (_controller.offset + delta).clamp(
        0,
        _controller.position.maxScrollExtent,
      ),
      duration: BookBiteTokens.motionDuration,
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = BookBiteLocalizations.of(context);
    return _Section(
      title: strings.relatedCatalogBooks,
      child: Row(
        children: [
          IconButton(
            tooltip: strings.isPersian
                ? 'ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™Ãƒâ€¹Ã…â€œÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¨ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â‚¬Å¾Ã‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¾ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂºÃƒÆ’Ã¢â‚¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢'
                : 'Previous books',
            onPressed: () => _move(-220),
            icon: const Icon(Icons.chevron_left_rounded),
          ),
          Expanded(
            child: SizedBox(
              height: 250,
              child: ListView.separated(
                controller: _controller,
                scrollDirection: Axis.horizontal,
                itemCount: widget.books.length,
                separatorBuilder: (_, _) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final book = widget.books[index];
                  final authors = book.authors.isEmpty
                      ? strings.authorUnavailable
                      : book.authors.join(', ');
                  return SizedBox(
                    width: 132,
                    child: Semantics(
                      button: true,
                      label: '${book.title}, $authors',
                      child: InkWell(
                        onTap: () => widget.onOpen(book),
                        borderRadius: BorderRadius.circular(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _Cover(
                                url: book.coverUrl,
                                label: book.title,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Directionality(
                              textDirection: _direction(book.title),
                              child: Text(
                                book.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          IconButton(
            tooltip: strings.isPersian
                ? 'ÃƒÆ’Ã†â€™Ãƒâ€¹Ã…â€œÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¨ÃƒÆ’Ã†â€™Ãƒâ€¹Ã…â€œÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¹ÃƒÆ’Ã†â€™Ãƒâ€¹Ã…â€œÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¯ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚ÂºÃƒÆ’Ã¢â‚¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢'
                : 'Next books',
            onPressed: () => _move(220),
            icon: const Icon(Icons.chevron_right_rounded),
          ),
        ],
      ),
    );
  }
}

class _Cover extends StatelessWidget {
  const _Cover({required this.url, required this.label, this.large = false});
  final Uri? url;
  final String label;
  final bool large;

  @override
  Widget build(BuildContext context) => Semantics(
    image: true,
    label: label,
    child: AspectRatio(
      aspectRatio: 2 / 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(large ? 24 : 16),
        child: url == null
            ? const _MissingCover()
            : Image.network(
                url.toString(),
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const _MissingCover(),
              ),
      ),
    ),
  );
}

class _MissingCover extends StatelessWidget {
  const _MissingCover();

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Container(
      color: BookBiteTokens.softSurface,
      alignment: Alignment.center,
      child: const Icon(
        Icons.menu_book_outlined,
        color: BookBiteTokens.atmosphericSage,
        size: 36,
      ),
    ),
  );
}

class _PinnedHeader extends StatelessWidget {
  const _PinnedHeader({
    required this.visible,
    required this.detail,
    required this.saveStatus,
    required this.onAdd,
  });
  final bool visible;
  final CatalogBookDetail detail;
  final PersonalBookSaveStatus saveStatus;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final strings = BookBiteLocalizations.of(context);
    final reduce = MediaQuery.of(context).disableAnimations;
    final authors = detail.authors.isEmpty
        ? strings.authorUnavailable
        : detail.authors.join(', ');
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        child: IgnorePointer(
          ignoring: !visible,
          child: AnimatedSwitcher(
            duration: reduce ? Duration.zero : BookBiteTokens.motionDuration,
            child: visible
                ? Material(
                    key: const ValueKey('catalog-detail-pinned-header'),
                    color: BookBiteTokens.surface,
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 72),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: BookBiteTokens.border),
                        ),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            tooltip: strings.back,
                            onPressed: context.pop,
                            icon: const Icon(Icons.arrow_back_rounded),
                          ),
                          ExcludeSemantics(
                            child: SizedBox(
                              width: 42,
                              height: 56,
                              child: _Cover(
                                url: detail.coverUrl,
                                label: detail.title,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  detail.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  authors,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          _CompactAddButton(
                            status: saveStatus,
                            onPressed: onAdd,
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(key: ValueKey('catalog-detail-no-header')),
          ),
        ),
      ),
    );
  }
}

class _StateView extends StatelessWidget {
  const _StateView({required this.state, required this.retry});
  final CatalogBookDetailState state;
  final VoidCallback retry;

  @override
  Widget build(BuildContext context) {
    final strings = BookBiteLocalizations.of(context);
    if (state.detailStatus == CatalogDetailStatus.loading) {
      return const _LoadingView();
    }
    final offline = state.isOffline;
    return Scaffold(
      backgroundColor: BookBiteTokens.canvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                tooltip: strings.back,
                onPressed: context.pop,
                icon: const Icon(Icons.arrow_back_rounded),
              ),
              const Spacer(),
              Icon(
                offline ? Icons.cloud_off_outlined : Icons.menu_book_outlined,
                size: 48,
                color: BookBiteTokens.atmosphericSage,
              ),
              const SizedBox(height: 24),
              Text(
                offline ? strings.connectionNeeded : strings.unavailableDetail,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(
                offline
                    ? strings.liveSearchNeedsConnection
                    : strings.catalogUnavailable,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: retry,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(strings.retry),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: BookBiteTokens.canvas,
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: IconButton(
              tooltip: BookBiteLocalizations.of(context).back,
              onPressed: context.pop,
              icon: const Icon(Icons.arrow_back_rounded),
            ),
          ),
          const SizedBox(height: 16),
          Align(
            child: _LoadingBlock(
              width: 210,
              height: 315,
              radius: BookBiteTokens.surfaceRadius,
            ),
          ),
          const SizedBox(height: 24),
          const _LoadingBlock(width: double.infinity, height: 32),
          const SizedBox(height: 12),
          const _LoadingBlock(width: 180, height: 20),
          const SizedBox(height: 28),
          const _LoadingBlock(width: double.infinity, height: 52),
        ],
      ),
    ),
  );
}

class _LoadingBlock extends StatelessWidget {
  const _LoadingBlock({
    required this.width,
    required this.height,
    this.radius = BookBiteTokens.controlRadius,
  });
  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: BookBiteTokens.softSurface,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: BookBiteTokens.border),
    ),
  );
}

TextDirection _direction(String text) =>
    RegExp(r'[\u0600-\u06FF]').hasMatch(text)
    ? TextDirection.rtl
    : TextDirection.ltr;

class _AddToLibraryButton extends StatelessWidget {
  const _AddToLibraryButton({
    required this.status,
    required this.onPressed,
    super.key,
  });

  final PersonalBookSaveStatus status;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final strings = BookBiteLocalizations.of(context);
    final waiting =
        status == PersonalBookSaveStatus.checking ||
        status == PersonalBookSaveStatus.saving;
    final saved = status == PersonalBookSaveStatus.saved;
    return Semantics(
      liveRegion: true,
      child: FilledButton.icon(
        style: saved
            ? FilledButton.styleFrom(
                disabledBackgroundColor: Theme.of(context).colorScheme.primary,
                disabledForegroundColor: Theme.of(
                  context,
                ).colorScheme.onPrimary,
              )
            : null,
        onPressed: waiting || saved ? null : onPressed,
        icon: waiting
            ? const SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(
                saved
                    ? Icons.check_circle_outline_rounded
                    : status == PersonalBookSaveStatus.failure
                    ? Icons.refresh_rounded
                    : Icons.library_add_outlined,
              ),
        label: Text(
          status == PersonalBookSaveStatus.saving
              ? strings.savingToLibrary
              : saved
              ? strings.savedState
              : status == PersonalBookSaveStatus.failure
              ? strings.tryAddAgain
              : strings.addToLibrary,
        ),
      ),
    );
  }
}

class _CompactAddButton extends StatelessWidget {
  const _CompactAddButton({required this.status, required this.onPressed});

  final PersonalBookSaveStatus status;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final strings = BookBiteLocalizations.of(context);
    final waiting =
        status == PersonalBookSaveStatus.checking ||
        status == PersonalBookSaveStatus.saving;
    final saved = status == PersonalBookSaveStatus.saved;
    return TextButton.icon(
      style: saved
          ? TextButton.styleFrom(
              disabledForegroundColor: Theme.of(context).colorScheme.primary,
            )
          : null,
      onPressed: waiting || saved ? null : onPressed,
      icon: waiting
          ? const SizedBox.square(
              dimension: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(
              saved
                  ? Icons.check_circle_outline_rounded
                  : status == PersonalBookSaveStatus.failure
                  ? Icons.refresh_rounded
                  : Icons.library_add_outlined,
            ),
      label: Text(
        status == PersonalBookSaveStatus.saving
            ? strings.savingShort
            : saved
            ? strings.savedState
            : status == PersonalBookSaveStatus.failure
            ? strings.retry
            : strings.compactAdd,
      ),
    );
  }
}

String _saveHelper(
  BookBiteLocalizations strings,
  PersonalBookSaveStatus status,
) => switch (status) {
  PersonalBookSaveStatus.saved => strings.savedOfflineHelper,
  PersonalBookSaveStatus.failure => strings.addToLibraryFailed,
  _ => strings.metadataSavedHelper,
};
