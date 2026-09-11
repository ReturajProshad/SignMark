// Smoke test for the SignMark home screen and routing scaffold.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pdf_editor/app.dart';

/// Sizes the test surface to the design size (375×812) so `flutter_screenutil`
/// scales 1:1, matching the phone layout the app is designed for.
void _usePortraitPhone(WidgetTester tester) {
  tester.view.physicalSize = const Size(375, 812);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  testWidgets('Home screen renders title and both entry points',
      (WidgetTester tester) async {
    _usePortraitPhone(tester);

    await tester.pumpWidget(const ProviderScope(child: SignMarkApp()));
    await tester.pumpAndSettle();

    expect(find.text('SignMark'), findsOneWidget);
    expect(find.text('Add Signature'), findsOneWidget);
    expect(find.text('Add Watermark'), findsOneWidget);
  });

  testWidgets('Tapping "Add Signature" navigates to the signature screen',
      (WidgetTester tester) async {
    _usePortraitPhone(tester);

    await tester.pumpWidget(const ProviderScope(child: SignMarkApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add Signature'));
    await tester.pumpAndSettle();

    expect(find.text('Signature builder'), findsOneWidget);
  });
}
