import 'package:bookbite/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('launches at the Reading Session root', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: BookBiteApp()));

    expect(find.text('Ready to read?'), findsOneWidget);
    expect(find.text('Reading Session'), findsWidgets);
  });

  testWidgets('switches to Persian with right-to-left text direction', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: BookBiteApp()));

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('فارسی'));
    await tester.pumpAndSettle();

    final welcome = find.text('برای خواندن آماده‌اید؟');
    expect(welcome, findsOneWidget);
    expect(Directionality.of(tester.element(welcome)), TextDirection.rtl);
  });
}
