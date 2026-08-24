import 'dart:async';

import 'package:bookbite/app/navigation/app_router.dart';
import 'package:bookbite/app/theme/bookbite_theme.dart';
import 'package:bookbite/core/presentation/localization/bookbite_localizations.dart';
import 'package:bookbite/features/onboarding/data/file_onboarding_store.dart';
import 'package:bookbite/features/onboarding/domain/onboarding_store.dart';
import 'package:bookbite/features/onboarding/presentation/bookbite_launch_page.dart';
import 'package:bookbite/features/onboarding/presentation/onboarding_page.dart';
import 'package:bookbite/features/discover/application/discover_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appLocaleProvider = NotifierProvider<AppLocaleNotifier, Locale>(
  AppLocaleNotifier.new,
);

class AppLocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() => const Locale('en');

  void setLocale(Locale locale) => state = locale;
}

class BookBiteApp extends ConsumerStatefulWidget {
  const BookBiteApp({
    this.onboardingStore,
    this.initializeApp,
    this.preloadDiscover,
    super.key,
  });

  final OnboardingStore? onboardingStore;
  final Future<void> Function()? initializeApp;
  final Future<void> Function(String language)? preloadDiscover;

  @override
  ConsumerState<BookBiteApp> createState() => _BookBiteAppState();
}

class _BookBiteAppState extends ConsumerState<BookBiteApp> {
  static const _minimumLaunchDuration = Duration(seconds: 3);

  late final OnboardingStore _onboardingStore =
      widget.onboardingStore ?? const FileOnboardingStore();
  late Future<bool> _bootstrap = _load();
  bool? _onboardingComplete;

  Future<bool> _load() async {
    final results = await Future.wait<Object?>([
      _loadOnboardingState(),
      Future<void>.delayed(_minimumLaunchDuration),
    ]);
    return results.first! as bool;
  }

  Future<bool> _loadOnboardingState() async {
    final initialize = widget.initializeApp;
    if (initialize != null) {
      await initialize();
    } else {
      await dotenv.load(fileName: '.env');
    }
    final language = ref.read(appLocaleProvider).languageCode;
    final preload = widget.preloadDiscover;
    unawaited(
      preload?.call(language) ??
          ref
              .read(discoverControllerProvider.notifier)
              .ensureRootLoaded(language),
    );
    return _onboardingStore.isComplete();
  }

  void _retryBootstrap() {
    setState(() => _bootstrap = _load());
  }

  Future<void> _completeOnboarding() async {
    await _onboardingStore.markComplete();
    if (mounted) setState(() => _onboardingComplete = true);
  }

  void _toggleLocale() {
    final current = ref.read(appLocaleProvider);
    ref
        .read(appLocaleProvider.notifier)
        .setLocale(
          current.languageCode == 'fa'
              ? const Locale('en')
              : const Locale('fa'),
        );
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(appLocaleProvider);
    return FutureBuilder<bool>(
      future: _bootstrap,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return _bootstrapApp(
            locale: locale,
            home: const BookBiteLaunchPage(),
          );
        }
        if (snapshot.hasError) {
          return _bootstrapApp(
            locale: locale,
            home: BookBiteLaunchPage(error: true, onRetry: _retryBootstrap),
          );
        }
        final completed = _onboardingComplete ?? snapshot.data ?? false;
        if (!completed) {
          return _bootstrapApp(
            locale: locale,
            home: OnboardingPage(
              onComplete: _completeOnboarding,
              onToggleLocale: _toggleLocale,
            ),
          );
        }
        return MaterialApp.router(
          key: const ValueKey('bookbite-main-app'),
          title: 'BookBite',
          debugShowCheckedModeBanner: false,
          restorationScopeId: 'bookbite_app',
          locale: locale,
          supportedLocales: BookBiteLocalizations.supportedLocales,
          localizationsDelegates: _localizationsDelegates,
          theme: BookBiteTheme.light,
          routerConfig: appRouter,
        );
      },
    );
  }

  MaterialApp _bootstrapApp({required Locale locale, required Widget home}) =>
      MaterialApp(
        key: const ValueKey('bookbite-bootstrap-app'),
        title: 'BookBite',
        debugShowCheckedModeBanner: false,
        locale: locale,
        supportedLocales: BookBiteLocalizations.supportedLocales,
        localizationsDelegates: _localizationsDelegates,
        theme: BookBiteTheme.light,
        home: home,
      );
}

const _localizationsDelegates = <LocalizationsDelegate<dynamic>>[
  BookBiteLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];
