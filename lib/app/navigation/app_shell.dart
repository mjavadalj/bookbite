import 'package:bookbite/core/presentation/widgets/bookbite_bottom_bar.dart';
import 'package:bookbite/app/navigation/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  const AppShell({required this.child, super.key});

  final Widget child;

  static const _locations = [
    '/reading-session',
    '/library',
    '/discover',
    '/journey',
    '/settings',
  ];

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.path;
    final selectedIndex = _locations.indexOf(currentLocation).clamp(0, 4);

    return Scaffold(
      body: SafeArea(child: child),
      bottomNavigationBar: BookBiteBottomBar(
        selectedIndex: selectedIndex,
        showCaptureActions: currentLocation != '/reading-session',
        onPhotoCapture: () =>
            const ReadingSessionCaptureRoute().push<void>(context),
        onVoiceCapture: () =>
            const ReadingSessionVoiceCaptureRoute().push<void>(context),
        onDestinationSelected: (index) => switch (index) {
          0 => const ReadingSessionRoute().go(context),
          1 => const LibraryRoute().go(context),
          2 => const DiscoverRoute().go(context),
          3 => const JourneyRoute().go(context),
          _ => const SettingsRoute().go(context),
        },
      ),
    );
  }
}
