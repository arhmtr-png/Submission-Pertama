// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:submission_pertama/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SubmissionPertamaApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Navigation and input test', (WidgetTester tester) async {
    await tester.pumpWidget(const SubmissionPertamaApp());

    // HomePage: Find and tap navigation button
    expect(find.text('Welcome to Submission Pertama!'), findsOneWidget);
    await tester.tap(find.text('Go to Details Page'));
    await tester.pumpAndSettle();

    // DetailsPage: Enter text and verify dynamic update
    expect(find.text('Enter something below:'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Dicoding');
    await tester.pump();
    expect(find.text('You typed: Dicoding'), findsOneWidget);

    // Tap back button and verify HomePage
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome to Submission Pertama!'), findsOneWidget);
  });
}
