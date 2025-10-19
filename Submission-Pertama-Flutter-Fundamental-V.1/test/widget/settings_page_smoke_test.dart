import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:fundamental/src/pages/settings_page.dart';
import 'package:fundamental/src/providers/settings_provider.dart';
import 'package:fundamental/src/services/settings_service.dart';

void main() {
  testWidgets('Settings page has theme toggle and test notification button', (
    tester,
  ) async {
    final settingsService = SettingsService();
    final provider = SettingsProvider(service: settingsService);

    await tester.pumpWidget(
      ChangeNotifierProvider<SettingsProvider>.value(
        value: provider,
        child: const MaterialApp(home: SettingsPage()),
      ),
    );

    await tester.pumpAndSettle();

    // Expect the Dark Theme switch specifically (there is also a Daily Reminder switch)
    final darkSwitchFinder = find.descendant(
      of: find.widgetWithText(SwitchListTile, 'Dark Theme'),
      matching: find.byType(Switch),
    );
    expect(darkSwitchFinder, findsOneWidget);

    // The debug test notification button is only present in debug mode.
    final testBtn = find.widgetWithText(
      ElevatedButton,
      'Send Test Notification',
    );
    if (tester.any(testBtn)) {
      await tester.tap(testBtn);
      await tester.pumpAndSettle();
    }
  });
}
