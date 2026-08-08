import 'package:bookbite/app/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const ProviderScope(child: BookBiteApp()));
}
