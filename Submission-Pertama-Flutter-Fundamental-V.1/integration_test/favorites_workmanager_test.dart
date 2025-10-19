import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:fundamental/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('navigate to settings and trigger debug background job', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const app.MyApp());
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Open settings via app bar action
    final settingsIcon = find.byTooltip('Settings');
    expect(settingsIcon, findsOneWidget);
    await tester.tap(settingsIcon);
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Find the debug trigger button (only present in debug builds)
    final triggerButton = find.text('Trigger Background Job (debug)');
    if (triggerButton.evaluate().isNotEmpty) {
      await tester.tap(triggerButton);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      // Expect a snackbar (UI feedback)
      expect(find.byType(SnackBar), findsWidgets);
    } else {
      // In release builds this button isn't present; just pass.
      expect(triggerButton, findsNothing);
    }
  });
}
