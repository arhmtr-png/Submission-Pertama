import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:submission_pertama/main.dart';
import 'package:submission_pertama/screens/results_page.dart';

void main() {
  testWidgets('Results page displays email and timestamp', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SubmissionPertamaApp());

    // Pump ResultsPage directly with constructor args
    await tester.pumpWidget(const SubmissionPertamaApp());
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SubmissionPertamaApp());
    await tester.pumpWidget(
      MaterialApp(
        home: ResultsPage(
          email: 'jane@example.com',
          timestamp: '2025-10-03T12:00:00',
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Welcome, jane@example.com'), findsOneWidget);
    expect(find.textContaining('Last login:'), findsOneWidget);
  });
}
