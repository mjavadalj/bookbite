import 'package:bookbite/core/presentation/localization/bookbite_localizations.dart';
import 'package:bookbite/core/presentation/widgets/foundation_page.dart';
import 'package:flutter/widgets.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = BookBiteLocalizations.of(context);
    return FoundationPage(title: strings.discover, message: strings.comingSoon);
  }
}
