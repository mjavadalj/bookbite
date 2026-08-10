// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $appShellRoute,
  $activeSearchRoute,
  $catalogBookDestinationRoute,
  $manualBookDestinationRoute,
];

RouteBase get $appShellRoute => ShellRouteData.$route(
  factory: $AppShellRouteExtension._fromState,
  routes: [
    GoRouteData.$route(
      path: '/reading-session',
      factory: $ReadingSessionRoute._fromState,
    ),
    GoRouteData.$route(path: '/library', factory: $LibraryRoute._fromState),
    GoRouteData.$route(path: '/discover', factory: $DiscoverRoute._fromState),
    GoRouteData.$route(path: '/journey', factory: $JourneyRoute._fromState),
    GoRouteData.$route(path: '/settings', factory: $SettingsRoute._fromState),
  ],
);

extension $AppShellRouteExtension on AppShellRoute {
  static AppShellRoute _fromState(GoRouterState state) => const AppShellRoute();
}

mixin $ReadingSessionRoute on GoRouteData {
  static ReadingSessionRoute _fromState(GoRouterState state) =>
      const ReadingSessionRoute();

  @override
  String get location => GoRouteData.$location('/reading-session');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $LibraryRoute on GoRouteData {
  static LibraryRoute _fromState(GoRouterState state) => const LibraryRoute();

  @override
  String get location => GoRouteData.$location('/library');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $DiscoverRoute on GoRouteData {
  static DiscoverRoute _fromState(GoRouterState state) => const DiscoverRoute();

  @override
  String get location => GoRouteData.$location('/discover');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $JourneyRoute on GoRouteData {
  static JourneyRoute _fromState(GoRouterState state) => const JourneyRoute();

  @override
  String get location => GoRouteData.$location('/journey');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SettingsRoute on GoRouteData {
  static SettingsRoute _fromState(GoRouterState state) => const SettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $activeSearchRoute => GoRouteData.$route(
  path: '/discover/search',
  factory: $ActiveSearchRoute._fromState,
);

mixin $ActiveSearchRoute on GoRouteData {
  static ActiveSearchRoute _fromState(GoRouterState state) =>
      ActiveSearchRoute(q: state.uri.queryParameters['q']);

  ActiveSearchRoute get _self => this as ActiveSearchRoute;

  @override
  String get location => GoRouteData.$location(
    '/discover/search',
    queryParams: {if (_self.q != null) 'q': _self.q},
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $catalogBookDestinationRoute => GoRouteData.$route(
  path: '/catalog/:provider/:id',
  factory: $CatalogBookDestinationRoute._fromState,
);

mixin $CatalogBookDestinationRoute on GoRouteData {
  static CatalogBookDestinationRoute _fromState(GoRouterState state) =>
      CatalogBookDestinationRoute(
        provider: state.pathParameters['provider']!,
        id: state.pathParameters['id']!,
        origin: state.uri.queryParameters['origin'],
      );

  CatalogBookDestinationRoute get _self => this as CatalogBookDestinationRoute;

  @override
  String get location => GoRouteData.$location(
    '/catalog/${Uri.encodeComponent(_self.provider)}/${Uri.encodeComponent(_self.id)}',
    queryParams: {if (_self.origin != null) 'origin': _self.origin},
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $manualBookDestinationRoute => GoRouteData.$route(
  path: '/manual-book',
  factory: $ManualBookDestinationRoute._fromState,
);

mixin $ManualBookDestinationRoute on GoRouteData {
  static ManualBookDestinationRoute _fromState(GoRouterState state) =>
      ManualBookDestinationRoute(query: state.uri.queryParameters['query']);

  ManualBookDestinationRoute get _self => this as ManualBookDestinationRoute;

  @override
  String get location => GoRouteData.$location(
    '/manual-book',
    queryParams: {if (_self.query != null) 'query': _self.query},
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
