import 'dart:async';

import 'package:bookbite/app/app.dart';
import 'package:bookbite/features/onboarding/domain/onboarding_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows branded launch loading while initialization is pending', (
    tester,
  ) async {
    final initialization = Completer<void>();
    await tester.pumpWidget(
      ProviderScope(
        child: BookBiteApp(
          onboardingStore: _MemoryOnboardingStore(completed: false),
          initializeApp: () => initialization.future,
        ),
      ),
    );

    expect(find.text('BookBite'), findsOneWidget);
    expect(find.text('Your space. Your books. Your journey.'), findsNothing);
    expect(
      find.byKey(const ValueKey('bookbite-launch-progress')),
      findsOneWidget,
    );

    initialization.complete();
    await tester.pump(const Duration(milliseconds: 2999));
    expect(find.text('Your reading life, together'), findsNothing);
    await tester.pump(const Duration(milliseconds: 1));
    await _pumpUi(tester);
    expect(find.text('Your reading life, together'), findsOneWidget);
    await _dispose(tester);
  });

  testWidgets('first run completes all onboarding pages and persists it', (
    tester,
  ) async {
    final store = _MemoryOnboardingStore(completed: false);
    await tester.pumpWidget(
      ProviderScope(
        child: BookBiteApp(
          onboardingStore: store,
          initializeApp: _initialize,
        ),
      ),
    );
    await _pumpUi(tester);

    expect(find.text('Your reading life, together'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await _pumpUi(tester);
    expect(find.text('Capture without losing your place'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await _pumpUi(tester);
    expect(find.text('Private and available offline'), findsOneWidget);
    await tester.tap(find.text('Get started'));
    await _pumpUi(tester);

    expect(store.completed, isTrue);
    expect(store.markCompleteCalls, 1);
    expect(find.text('Ready to read?'), findsOneWidget);
    await _dispose(tester);
  });

  testWidgets('completed onboarding is skipped after restart', (tester) async {
    final store = _MemoryOnboardingStore(completed: true);
    await tester.pumpWidget(
      ProviderScope(
        child: BookBiteApp(
          onboardingStore: store,
          initializeApp: _initialize,
        ),
      ),
    );
    await _pumpUi(tester);

    expect(find.text('Ready to read?'), findsOneWidget);
    expect(find.text('Your reading life, together'), findsNothing);
    await _dispose(tester);
  });

  testWidgets('onboarding can switch to Persian RTL', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: BookBiteApp(
          onboardingStore: _MemoryOnboardingStore(completed: false),
          initializeApp: _initialize,
        ),
      ),
    );
    await _pumpUi(tester);

    await tester.tap(find.text('فارسی'));
    await _pumpUi(tester);
    final title = find.text('زندگی مطالعه شما، یک‌جا');
    expect(title, findsOneWidget);
    expect(Directionality.of(tester.element(title)), TextDirection.rtl);
    await _dispose(tester);
  });

  testWidgets('onboarding remains scrollable at 200 percent text', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(375, 667));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: ProviderScope(
          child: BookBiteApp(
            onboardingStore: _MemoryOnboardingStore(completed: false),
            initializeApp: _initialize,
          ),
        ),
      ),
    );
    await _pumpUi(tester);

    expect(find.text('Your reading life, together'), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(tester.takeException(), isNull);
    await _dispose(tester);
  });
}

Future<void> _initialize() async {}

Future<void> _pumpUi(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(seconds: 3));
}

Future<void> _dispose(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 1));
}

class _MemoryOnboardingStore implements OnboardingStore {
  _MemoryOnboardingStore({required this.completed});

  bool completed;
  int markCompleteCalls = 0;

  @override
  Future<bool> isComplete() async => completed;

  @override
  Future<void> markComplete() async {
    markCompleteCalls++;
    completed = true;
  }
}
