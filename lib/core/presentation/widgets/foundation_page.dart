import 'package:bookbite/app/theme/bookbite_theme.dart';
import 'package:flutter/material.dart';

class FoundationPage extends StatelessWidget {
  const FoundationPage({
    required this.title,
    required this.message,
    this.action,
    super.key,
  });

  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Padding(
        padding: const EdgeInsets.all(BookBiteTokens.space3),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: BookBiteTokens.space2),
                Text(message, style: Theme.of(context).textTheme.bodyLarge),
                if (action case final action?) ...[
                  const SizedBox(height: BookBiteTokens.space3),
                  action,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
