import 'package:bookbite/app/app.dart';
import 'package:bookbite/core/presentation/localization/bookbite_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = BookBiteLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          strings.settings,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 24),
        ListTile(
          title: Text(strings.language),
          subtitle: Text(strings.switchLanguage),
          trailing: const Icon(Icons.language),
          onTap: () {
            final next = strings.isPersian
                ? const Locale('en')
                : const Locale('fa');
            ref.read(appLocaleProvider.notifier).setLocale(next);
          },
        ),
      ],
    );
  }
}
