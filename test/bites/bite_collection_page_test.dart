import 'package:bookbite/app/theme/bookbite_theme.dart';
import 'package:bookbite/core/data/database/app_database.dart';
import 'package:bookbite/core/data/database/database_providers.dart';
import 'package:bookbite/features/bites/presentation/bite_collection_page.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('book bites can be searched and filtered by persisted tags', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(400, 850));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final database = AppDatabase.memory();
    addTearDown(database.close);
    final now = DateTime.utc(2026, 8, 23).millisecondsSinceEpoch;
    await database
        .into(database.personalBookEntries)
        .insert(
          PersonalBookEntriesCompanion.insert(
            id: 'book',
            title: 'Test Book',
            authorsJson: '[]',
            snapshotJson: '{"version":1,"title":"Test Book"}',
            createdAt: now,
            updatedAt: now,
          ),
        );
    await database
        .into(database.biteEntries)
        .insert(
          BiteEntriesCompanion.insert(
            id: 'quote',
            sourceKind: 'pageImage',
            extractionStatus: 'ready',
            extractedText: const Value('A memorable orchard sentence'),
            tagsJson: const Value('["quote"]'),
            personalBookId: const Value('book'),
            createdAt: now,
            updatedAt: now,
          ),
        );
    await database
        .into(database.biteEntries)
        .insert(
          BiteEntriesCompanion.insert(
            id: 'idea',
            sourceKind: 'voiceRecording',
            extractionStatus: 'ready',
            extractedText: const Value('Build this idea tomorrow'),
            tagsJson: const Value('["idea"]'),
            personalBookId: const Value('book'),
            createdAt: now + 1,
            updatedAt: now + 1,
          ),
        );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(database)],
        child: MaterialApp(
          theme: BookBiteTheme.light,
          home: const BiteCollectionPage(
            kind: BiteCollectionKind.book,
            ownerId: 'book',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('A memorable orchard sentence'), findsOneWidget);
    expect(find.text('Build this idea tomorrow'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'orchard');
    await tester.pumpAndSettle();
    expect(find.text('A memorable orchard sentence'), findsOneWidget);
    expect(find.text('Build this idea tomorrow'), findsNothing);

    await tester.enterText(find.byType(TextField), '');
    await tester.tap(find.text('Ideas 1'));
    await tester.pumpAndSettle();
    expect(find.text('A memorable orchard sentence'), findsNothing);
    expect(find.text('Build this idea tomorrow'), findsOneWidget);
  });
}
