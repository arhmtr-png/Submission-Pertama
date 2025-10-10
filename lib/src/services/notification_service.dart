import 'package:flutter_local_notifications/flutter_local_notifications.dart';

typedef NotificationSelectCallback = void Function(String? payload);

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init({NotificationSelectCallback? onSelect}) async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        try {
          final payload = response.payload;
          if (onSelect != null) {
            onSelect(payload);
          }
        } catch (_) {
          // ignore
        }
      },
    );
    // Note: requesting runtime POST_NOTIFICATIONS permission is handled by
    // the app/OS or via a permission helper. Avoid calling plugin-specific
    // APIs here to keep unit tests platform-independent.
  }

  static Future<void> showDailyReminder({required int id, required String title, required String body, String? payload}) async {
    const androidDetails = AndroidNotificationDetails('daily_reminder', 'Daily Reminder', importance: Importance.max, priority: Priority.high, styleInformation: BigTextStyleInformation(''));
    const iosDetails = DarwinNotificationDetails();
    await _plugin.show(id, title, body, const NotificationDetails(android: androidDetails, iOS: iosDetails), payload: payload);
  }

  /// Debug helper: show a test notification immediately. Useful during development
  /// to verify that notifications are working on a device/emulator without waiting
  /// for scheduled Workmanager tasks.
  static Future<void> showTestNotification() async {
    await showDailyReminder(id: 9999, title: 'Test Notification', body: 'This is a test notification from the app.', payload: 'test');
  }
}
