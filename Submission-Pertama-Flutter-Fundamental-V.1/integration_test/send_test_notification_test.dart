import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:fundamental/main.dart' as app;
import 'package:fundamental/src/pages/settings_page.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'Settings: Send Test Notification button shows snackbar',
    (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Ensure notification permission is granted for the test (Android 13+).
      // Try requesting the permission up to 3 times with a short delay.
      try {
        final maxTries = 3;
        var attempt = 0;
        while (attempt < maxTries &&
            !(await Permission.notification.isGranted)) {
          attempt++;
          final status = await Permission.notification.request();
          if (status.isGranted) break;
          // Small delay before retrying to allow system permission dialog handling
          await Future<void>.delayed(const Duration(seconds: 2));
        }
        if (!(await Permission.notification.isGranted)) {
          // If permission still isn't granted, fail early with a helpful message.
          fail(
            'Notification permission not granted. Grant notifications to the app and re-run the test.',
          );
        }
      } catch (e) {
        // Some environments may not support permission_handler; continue but warn.
        // ignore: avoid_print
        print(
          'Warning: could not request notification permission programmatically: $e',
        );
      }

      // Navigate to settings using the global navigator key
      app.navigatorKey.currentState?.pushNamed(SettingsPage.routeName);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Find the Send Test Notification button by its test key
      final sendButton = find.byKey(const Key('send_test_notification'));
      expect(sendButton, findsOneWidget);

      await tester.tap(sendButton);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Confirm the snackbar message appears
      expect(find.text('Test notification sent'), findsOneWidget);
    },
    timeout: const Timeout(Duration(seconds: 60)),
  );
}
