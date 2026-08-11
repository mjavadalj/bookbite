import 'package:bookbite/app/navigation/app_shell.dart';
import 'package:bookbite/features/discover/presentation/active_search_page.dart';
import 'package:bookbite/features/discover/presentation/discover_destination_placeholders.dart';
import 'package:bookbite/features/discover/presentation/discover_page.dart';
import 'package:bookbite/features/catalog/presentation/catalog_book_detail_page.dart';
import 'package:bookbite/features/journey/presentation/journey_page.dart';
import 'package:bookbite/features/library/presentation/library_page.dart';
import 'package:bookbite/features/reading_session/presentation/reading_session_page.dart';
import 'package:bookbite/features/settings/presentation/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'app_router.g.dart';

final appRouter = GoRouter(
  initialLocation: const ReadingSessionRoute().location,
  restorationScopeId: 'bookbite_router',
  routes: $appRoutes,
);

@TypedShellRoute<AppShellRoute>(
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<ReadingSessionRoute>(path: '/reading-session'),
    TypedGoRoute<LibraryRoute>(path: '/library'),
    TypedGoRoute<DiscoverRoute>(path: '/discover'),
    TypedGoRoute<JourneyRoute>(path: '/journey'),
    TypedGoRoute<SettingsRoute>(path: '/settings'),
  ],
)
class AppShellRoute extends ShellRouteData {
  const AppShellRoute();

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) =>
      AppShell(child: navigator);
}

class ReadingSessionRoute extends GoRouteData with $ReadingSessionRoute {
  const ReadingSessionRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      const NoTransitionPage(
        restorationId: 'reading_session_root',
        child: ReadingSessionPage(),
      );
}

class LibraryRoute extends GoRouteData with $LibraryRoute {
  const LibraryRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      const NoTransitionPage(
        restorationId: 'library_root',
        child: LibraryPage(),
      );
}

class DiscoverRoute extends GoRouteData with $DiscoverRoute {
  const DiscoverRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      const NoTransitionPage(
        restorationId: 'discover_root',
        child: DiscoverPage(),
      );
}

class JourneyRoute extends GoRouteData with $JourneyRoute {
  const JourneyRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      const NoTransitionPage(
        restorationId: 'journey_root',
        child: JourneyPage(),
      );
}

class SettingsRoute extends GoRouteData with $SettingsRoute {
  const SettingsRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      const NoTransitionPage(
        restorationId: 'settings_root',
        child: SettingsPage(),
      );
}

@TypedGoRoute<ActiveSearchRoute>(path: '/discover/search')
class ActiveSearchRoute extends GoRouteData with $ActiveSearchRoute {
  const ActiveSearchRoute({this.q});

  final String? q;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        restorationId: 'discover_active_search',
        child: ActiveSearchPage(initialQuery: q),
      );
}

@TypedGoRoute<CatalogBookDestinationRoute>(path: '/catalog/:provider/:id')
class CatalogBookDestinationRoute extends GoRouteData
    with $CatalogBookDestinationRoute {
  const CatalogBookDestinationRoute({
    required this.provider,
    required this.id,
    this.origin,
  });

  final String provider;
  final String id;
  final String? origin;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        restorationId: 'catalog_book_destination',
        child: CatalogBookDetailPage(
          provider: provider,
          bookId: id,
          origin: origin,
        ),
      );
}

@TypedGoRoute<ManualBookDestinationRoute>(path: '/manual-book')
class ManualBookDestinationRoute extends GoRouteData
    with $ManualBookDestinationRoute {
  const ManualBookDestinationRoute({this.query});

  final String? query;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        restorationId: 'manual_book_destination',
        child: ManualBookDestinationPlaceholder(query: query),
      );
}
