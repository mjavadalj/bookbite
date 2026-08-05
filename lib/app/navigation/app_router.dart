import 'package:bookbite/app/navigation/app_shell.dart';
import 'package:bookbite/features/discover/presentation/discover_page.dart';
import 'package:bookbite/features/journey/presentation/journey_page.dart';
import 'package:bookbite/features/library/presentation/library_page.dart';
import 'package:bookbite/features/reading_session/presentation/reading_session_page.dart';
import 'package:bookbite/features/settings/presentation/settings_page.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/reading-session',
  restorationScopeId: 'bookbite_router',
  routes: [
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
