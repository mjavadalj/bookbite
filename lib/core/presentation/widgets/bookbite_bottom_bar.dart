import 'package:bookbite/app/theme/bookbite_theme.dart';
import 'package:bookbite/core/presentation/localization/bookbite_localizations.dart';
import 'package:flutter/material.dart';

class BookBiteBottomBar extends StatelessWidget {
  const BookBiteBottomBar({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.showCaptureActions,
    required this.onPhotoCapture,
    required this.onVoiceCapture,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool showCaptureActions;
  final VoidCallback onPhotoCapture;
  final VoidCallback onVoiceCapture;

  @override
  Widget build(BuildContext context) {
    final strings = BookBiteLocalizations.of(context);
    final destinations = [
      _Destination(
        label: strings.sessionNavigation,
        icon: Icons.menu_book_outlined,
        selectedIcon: Icons.menu_book_rounded,
      ),
      _Destination(
        label: strings.library,
        icon: Icons.local_library_outlined,
        selectedIcon: Icons.local_library_rounded,
      ),
      _Destination(
        label: strings.discover,
        icon: Icons.explore_outlined,
        selectedIcon: Icons.explore_rounded,
      ),
      _Destination(
        label: strings.journey,
        icon: Icons.route_outlined,
        selectedIcon: Icons.route_rounded,
      ),
      _Destination(
        label: strings.settings,
        icon: Icons.settings_outlined,
        selectedIcon: Icons.settings_rounded,
      ),
    ];

    return Material(
      color: BookBiteTokens.surface,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showCaptureActions) ...[
              const SizedBox(height: BookBiteTokens.space1),
              _CaptureActions(
                strings: strings,
                onPhotoCapture: onPhotoCapture,
                onVoiceCapture: onVoiceCapture,
              ),
              const SizedBox(height: BookBiteTokens.space1),
            ],
            const Divider(height: 1, color: BookBiteTokens.border),
            SizedBox(
              height: 82,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var index = 0; index < destinations.length; index++)
                    Expanded(
                      child: _NavigationItem(
                        destination: destinations[index],
                        selected: index == selectedIndex,
                        onPressed: () => onDestinationSelected(index),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CaptureActions extends StatelessWidget {
  const _CaptureActions({
    required this.strings,
    required this.onPhotoCapture,
    required this.onVoiceCapture,
  });

  final BookBiteLocalizations strings;
  final VoidCallback onPhotoCapture;
  final VoidCallback onVoiceCapture;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 640),
      child: Container(
        height: 52,
        margin: const EdgeInsets.symmetric(horizontal: 32),
        decoration: BoxDecoration(
          color: BookBiteTokens.surface,
          border: Border.all(color: BookBiteTokens.border),
          borderRadius: BorderRadius.circular(26),
        ),
        child: Row(
          children: [
            Expanded(
              child: _CaptureAction(
                icon: Icons.photo_camera_outlined,
                label: strings.photo,
                onPressed: onPhotoCapture,
              ),
            ),
            const SizedBox(
              height: 24,
              child: VerticalDivider(width: 1, color: BookBiteTokens.border),
            ),
            Expanded(
              child: _CaptureAction(
                icon: Icons.mic_none_rounded,
                label: strings.voice,
                onPressed: onVoiceCapture,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CaptureAction extends StatelessWidget {
  const _CaptureAction({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: true,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 27, color: BookBiteTokens.primary),
              const SizedBox(width: BookBiteTokens.space1),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: BookBiteTokens.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationItem extends StatelessWidget {
  const _NavigationItem({
    required this.destination,
    required this.selected,
    required this.onPressed,
  });

  final _Destination destination;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final labelColor = selected
        ? BookBiteTokens.primary
        : BookBiteTokens.navigationIcon;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return Semantics(
      button: true,
      selected: selected,
      label: destination.label,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
        child: Material(
          color: selected ? BookBiteTokens.selectedSurface : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: reduceMotion
                      ? Duration.zero
                      : const Duration(milliseconds: 180),
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: selected
                        ? BookBiteTokens.primary
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    selected ? destination.selectedIcon : destination.icon,
                    size: 26,
                    color: selected
                        ? BookBiteTokens.surface
                        : BookBiteTokens.navigationIcon,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  destination.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: labelColor,
                    fontSize: 11,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Destination {
  const _Destination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}
