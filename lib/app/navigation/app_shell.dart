import 'package:bookbite/core/presentation/widgets/bookbite_bottom_bar.dart';
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
        onDestinationSelected: (index) => context.go(_locations[index]),
      ),
    );
  }
}
