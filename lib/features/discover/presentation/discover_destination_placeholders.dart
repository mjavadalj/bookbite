import 'package:bookbite/core/presentation/localization/bookbite_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bookbite/features/library/application/personal_book_providers.dart';

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

class ManualBookDestinationPlaceholder extends ConsumerStatefulWidget {
  const ManualBookDestinationPlaceholder({this.query, super.key});
  final String? query;

  @override
  ConsumerState<ManualBookDestinationPlaceholder> createState() =>
      _ManualBookDestinationState();
}

class _ManualBookDestinationState
    extends ConsumerState<ManualBookDestinationPlaceholder> {
  late final TextEditingController _title;
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.query?.trim() ?? '');
  }

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

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
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
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
            const SizedBox(height: 24),
            TextFormField(
              controller: _title,
              autofocus: true,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: strings.bookTitle,
                helperText: strings.bookTitleRequired,
                border: const OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? strings.bookTitleRequired
                  : null,
              onFieldSubmitted: (_) => _save(),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(strings.createBook),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (_saving || !(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    try {
      final book = await ref
          .read(createManualPersonalBookProvider)
          .call(_title.text);
      if (mounted) context.go('/library/book/${book.id}');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
