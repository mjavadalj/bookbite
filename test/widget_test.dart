import 'package:bookbite/app/app.dart';
import 'package:bookbite/features/onboarding/domain/onboarding_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('launches at the Reading Session root', (tester) async {
    await tester.pumpWidget(_completedApp());
    await _pumpUi(tester);

    expect(find.text('Ready to read?'), findsOneWidget);
    expect(find.text('Reading Session'), findsWidgets);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  });

  testWidgets('switches to Persian with right-to-left text direction', (
    tester,
  ) async {
    await tester.pumpWidget(_completedApp());
    await _pumpUi(tester);

    await tester.tap(find.text('Settings'));
    await _pumpUi(tester);
    await tester.tap(find.text('فارسی'));
    await _pumpUi(tester);

    final settings = find.text('تنظیمات');
    expect(settings, findsWidgets);
    expect(
      Directionality.of(tester.element(settings.first)),
      TextDirection.rtl,
    );
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  });
}

Widget _completedApp() => ProviderScope(
  child: BookBiteApp(
    onboardingStore: _CompletedOnboardingStore(),
    initializeApp: _initialize,
  ),
);

Future<void> _initialize() async {}

Future<void> _pumpUi(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

class _CompletedOnboardingStore implements OnboardingStore {
  @override
  Future<bool> isComplete() async => true;

  @override
  Future<void> markComplete() async {}
}
