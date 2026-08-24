import 'package:bookbite/app/theme/bookbite_theme.dart';
import 'package:bookbite/core/data/database/app_database.dart';
import 'package:bookbite/core/data/database/database_providers.dart';
import 'package:bookbite/core/presentation/localization/bookbite_localizations.dart';
import 'package:bookbite/features/journey/presentation/journey_page.dart';
import 'package:bookbite/features/library/presentation/library_page.dart';
import 'package:bookbite/features/reading_session/presentation/reading_session_page.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.memory();
  });

  tearDown(() => database.close());

  testWidgets('library renders a scrollable shelf from persisted books', (
    tester,
  ) async {
    await _setPhoneSize(tester);
    await _insertBook(database);

    await tester.pumpWidget(_testApp(database, const LibraryPage()));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    expect(find.text('Welcome back,'), findsOneWidget);
    expect(find.text('My bookshelf'), findsOneWidget);
    expect(find.text('The Alchemist'), findsOneWidget);
    expect(find.byType(ListView), findsWidgets);
    await _disposePage(tester);
  });

  testWidgets('book selection opens a stopped timer before session creation', (
    tester,
  ) async {
    await _setPhoneSize(tester);
    await _insertBook(database);

    await tester.pumpWidget(_testApp(database, const ReadingSessionPage()));
    await tester.pumpAndSettle();

    expect(find.text('Start a Session'), findsOneWidget);
    expect(find.text('Choose a book to begin'), findsOneWidget);
    expect(find.text('YOUR LIBRARY'), findsOneWidget);
    expect(find.text('Back'), findsNothing);
    expect(
      await database.select(database.readingSessionEntries).get(),
      isEmpty,
    );

    await tester.tap(find.text('The Alchemist'));
    await tester.pumpAndSettle();

    expect(find.text('TIME READING'), findsOneWidget);
    expect(find.text('00:00'), findsOneWidget);
    expect(find.byTooltip('Start session'), findsOneWidget);
    expect(find.text('Start with this book?'), findsNothing);
    expect(find.text('Begin reading'), findsNothing);
    expect(
      await database.select(database.readingSessionEntries).get(),
      isEmpty,
    );

    await tester.tap(find.byTooltip('Start session'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(
      await database.select(database.readingSessionEntries).get(),
      hasLength(1),
    );
    await _disposePage(tester);
  });

  testWidgets('journey shows persisted reading progression and heatmap', (
    tester,
  ) async {
    await _setPhoneSize(tester);
    final now = DateTime.now().toUtc();
    await database
        .into(database.readingSessionEntries)
        .insert(
          ReadingSessionEntriesCompanion.insert(
            id: 'completed-session',
            startedAt: now
                .subtract(const Duration(minutes: 90))
                .millisecondsSinceEpoch,
            endedAt: Value(now.millisecondsSinceEpoch),
            createdAt: now.millisecondsSinceEpoch,
            updatedAt: now.millisecondsSinceEpoch,
          ),
        );

    await tester.pumpWidget(_testApp(database, const JourneyPage()));
    await tester.pumpAndSettle();

    expect(find.text('Level 2 reader'), findsOneWidget);
    expect(find.text('Reading activity'), findsOneWidget);
    expect(find.text('1'), findsWidgets);
    await _disposePage(tester);
  });

  testWidgets('photo OCR and voice transcripts can both be edited and saved', (
    tester,
  ) async {
    await _setPhoneSize(tester);
    final now = DateTime.now().toUtc().millisecondsSinceEpoch;
    await database
        .into(database.readingSessionEntries)
        .insert(
          ReadingSessionEntriesCompanion.insert(
            id: 'active-session',
            startedAt: now,
            createdAt: now,
            updatedAt: now,
          ),
        );
    await _insertReadyBite(
      database,
      id: 'photo',
      kind: 'pageImage',
      text: 'photo original',
      timestamp: now,
    );
    await _insertReadyBite(
      database,
      id: 'voice',
      kind: 'voiceRecording',
      text: 'voice original',
      timestamp: now + 1,
    );

    await tester.pumpWidget(_testApp(database, const ReadingSessionPage()));
    await tester.pumpAndSettle();

    await _editBite(
      tester,
      original: 'voice original',
      replacement: 'voice edited',
    );
    await _editBite(
      tester,
      original: 'photo original',
      replacement: 'photo edited',
    );

    final rows = await database.select(database.biteEntries).get();
    expect(
      rows.singleWhere((row) => row.id == 'voice').extractedText,
      'voice edited',
    );
    expect(
      rows.singleWhere((row) => row.id == 'photo').extractedText,
      'photo edited',
    );
    await _disposePage(tester);
  });

  testWidgets(
    'library supports Persian RTL and 200 percent text on a small phone',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(375, 667));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await _insertBook(database);

      await tester.pumpWidget(
        _testApp(
          database,
          const LibraryPage(),
          locale: const Locale('fa'),
          textScaler: const TextScaler.linear(2),
        ),
      );
      await tester.pumpAndSettle();

      final shelfTitle = find.text('قفسه کتاب من');
      await tester.scrollUntilVisible(shelfTitle, 400);
      expect(shelfTitle, findsOneWidget);
      expect(Directionality.of(tester.element(shelfTitle)), TextDirection.rtl);
      expect(tester.takeException(), isNull);
      await _disposePage(tester);
    },
  );

  testWidgets('journey remains usable in phone landscape', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 375));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_testApp(database, const JourneyPage()));
    await tester.pumpAndSettle();

    final activity = find.text('Reading activity');
    await tester.scrollUntilVisible(activity, 250);
    expect(activity, findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
    await _disposePage(tester);
  });
}

Future<void> _setPhoneSize(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(400, 850));
  addTearDown(() => tester.binding.setSurfaceSize(null));
}

Future<void> _disposePage(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 1));
}

Widget _testApp(
  AppDatabase database,
  Widget page, {
  Locale locale = const Locale('en'),
  TextScaler textScaler = TextScaler.noScaling,
}) => ProviderScope(
  overrides: [appDatabaseProvider.overrideWithValue(database)],
  child: MaterialApp(
    locale: locale,
    supportedLocales: BookBiteLocalizations.supportedLocales,
    localizationsDelegates: const [
      BookBiteLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    theme: BookBiteTheme.light,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: textScaler),
      child: child!,
    ),
    home: Scaffold(body: SafeArea(child: page)),
  ),
);

Future<void> _insertBook(AppDatabase database) async {
  final now = DateTime.now().toUtc().millisecondsSinceEpoch;
  await database
      .into(database.personalBookEntries)
      .insert(
        PersonalBookEntriesCompanion.insert(
          id: 'book',
          title: 'The Alchemist',
          authorsJson: '["Paulo Coelho"]',
          snapshotJson: '{"version":1,"title":"The Alchemist"}',
          createdAt: now,
          updatedAt: now,
        ),
      );
}

Future<void> _insertReadyBite(
  AppDatabase database, {
  required String id,
  required String kind,
  required String text,
  required int timestamp,
}) => database
    .into(database.biteEntries)
    .insert(
      BiteEntriesCompanion.insert(
        id: id,
        sourceKind: kind,
        extractionStatus: 'ready',
        extractedText: Value(text),
        readingSessionId: const Value('active-session'),
        createdAt: timestamp,
        updatedAt: timestamp,
      ),
    );

Future<void> _editBite(
  WidgetTester tester, {
  required String original,
  required String replacement,
}) async {
  final card = find.ancestor(
    of: find.text(original),
    matching: find.byType(Card),
  );
  final edit = find.descendant(of: card, matching: find.byTooltip('Edit text'));
  await tester.tap(edit);
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField), replacement);
  await tester.tap(find.text('Save changes'));
  await tester.pumpAndSettle();
  expect(find.text(replacement), findsOneWidget);
}
