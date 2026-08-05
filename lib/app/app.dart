import 'package:bookbite/app/navigation/app_router.dart';
import 'package:bookbite/app/theme/bookbite_theme.dart';
import 'package:bookbite/core/presentation/localization/bookbite_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appLocaleProvider = NotifierProvider<AppLocaleNotifier, Locale>(
  AppLocaleNotifier.new,
);

class AppLocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() => const Locale('en');

  void setLocale(Locale locale) => state = locale;
}

class BookBiteApp extends ConsumerWidget {
  const BookBiteApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appLocaleProvider);

    return MaterialApp.router(
      title: 'BookBite',
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'bookbite_app',
      locale: locale,
      supportedLocales: BookBiteLocalizations.supportedLocales,
      localizationsDelegates: const [BookBiteLocalizations.delegate],
      theme: BookBiteTheme.light,
      routerConfig: appRouter,
    );
  }
}
