import 'package:bookbite/core/presentation/localization/bookbite_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Typed hand-off surfaces only. Their complete behavior belongs to the later
/// CatalogBook and PersonalBook roadmap milestones.
class CatalogBookDestinationPlaceholder extends StatelessWidget {
  const CatalogBookDestinationPlaceholder({
    required this.provider,
    required this.bookId,
    super.key,
  });
  final String provider;
  final String bookId;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        onPressed: context.pop,
        icon: const Icon(Icons.arrow_back_rounded),
      ),
    ),
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            BookBiteLocalizations.of(context).catalogResults,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Text(
            '$provider · $bookId',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          Text(
            BookBiteLocalizations.of(context).catalogBookOverviewComingSoon,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    ),
  );
}

class ManualBookDestinationPlaceholder extends StatelessWidget {
  const ManualBookDestinationPlaceholder({this.query, super.key});
  final String? query;
  @override
  Widget build(BuildContext context) {
    final strings = BookBiteLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: strings.cancel,
          onPressed: context.pop,
          icon: const Icon(Icons.close_rounded),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.manualCreateTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              strings.manualCreateDescription,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (query case final seed? when seed.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(seed, style: Theme.of(context).textTheme.titleLarge),
            ],
          ],
        ),
      ),
    );
  }
}
