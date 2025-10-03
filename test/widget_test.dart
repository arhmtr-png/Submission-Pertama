// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:submission_pertama/main.dart';

void main() {
  testWidgets('Simple home smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SubmissionPertamaApp());

    // Home should show Sign In and Open Gallery actions
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Open Gallery'), findsOneWidget);
  });
}
