import 'package:bookbite/app/navigation/app_shell.dart';
import 'package:bookbite/features/discover/presentation/discover_page.dart';
import 'package:bookbite/features/discover/presentation/active_search_page.dart';
import 'package:bookbite/features/discover/presentation/discover_destination_placeholders.dart';
import 'package:bookbite/features/journey/presentation/journey_page.dart';
import 'package:bookbite/features/library/presentation/library_page.dart';
import 'package:bookbite/features/reading_session/presentation/reading_session_page.dart';
import 'package:bookbite/features/settings/presentation/settings_page.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

final appRouter = GoRouter(
  initialLocation: '/reading-session',
  restorationScopeId: 'bookbite_router',
  routes: [
    GoRoute(
      path: '/discover/search',
      name: 'activeSearch',
      pageBuilder: (context, state) => MaterialPage<void>(
        restorationId: 'discover_active_search',
        child: ActiveSearchPage(initialQuery: state.uri.queryParameters['q']),
      ),
    ),
    GoRoute(
      path: '/catalog/:provider/:id',
      name: 'catalogBookDestination',
      pageBuilder: (context, state) => MaterialPage<void>(
        restorationId: 'catalog_book_destination',
        child: CatalogBookDestinationPlaceholder(
          provider: state.pathParameters['provider']!,
          bookId: state.pathParameters['id']!,
        ),
      ),
    ),
    GoRoute(
      path: '/manual-book',
      name: 'manualBookDestination',
      pageBuilder: (context, state) => MaterialPage<void>(
        restorationId: 'manual_book_destination',
        child: ManualBookDestinationPlaceholder(
          query: state.uri.queryParameters['query'],
        ),
      ),
    ),
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/reading-session',
          name: 'readingSession',
          pageBuilder: (context, state) => const NoTransitionPage(
            restorationId: 'reading_session_root',
            child: ReadingSessionPage(),
          ),
        ),
        GoRoute(
          path: '/library',
          name: 'library',
          pageBuilder: (context, state) => const NoTransitionPage(
            restorationId: 'library_root',
            child: LibraryPage(),
          ),
        ),
        GoRoute(
          path: '/discover',
          name: 'discover',
          pageBuilder: (context, state) => const NoTransitionPage(
            restorationId: 'discover_root',
            child: DiscoverPage(),
          ),
        ),
        GoRoute(
          path: '/journey',
          name: 'journey',
          pageBuilder: (context, state) => const NoTransitionPage(
            restorationId: 'journey_root',
            child: JourneyPage(),
          ),
        ),
        GoRoute(
          path: '/settings',
          name: 'settings',
          pageBuilder: (context, state) => const NoTransitionPage(
            restorationId: 'settings_root',
            child: SettingsPage(),
          ),
        ),
      ],
    ),
  ],
);
