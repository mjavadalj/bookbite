import 'package:bookbite/core/presentation/localization/bookbite_localizations.dart';
import 'package:bookbite/core/presentation/widgets/foundation_page.dart';
import 'package:flutter/material.dart';

class ReadingSessionPage extends StatelessWidget {
  const ReadingSessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = BookBiteLocalizations.of(context);
    return FoundationPage(
      title: strings.welcome,
      message: strings.idleDescription,
      action: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          FilledButton.icon(
            onPressed: null,
            icon: const Icon(Icons.play_arrow),
            label: Text(strings.startSession),
          ),
          OutlinedButton.icon(
            onPressed: null,
            icon: const Icon(Icons.photo_camera_outlined),
            label: Text(strings.photo),
          ),
          OutlinedButton.icon(
            onPressed: null,
            icon: const Icon(Icons.mic_none_outlined),
            label: Text(strings.voice),
          ),
        ],
      ),
    );
  }
}
