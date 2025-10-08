import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _plugin.initialize(const InitializationSettings(android: android, iOS: ios));
  }

  static Future<void> showDailyReminder({required int id, required String title, required String body, String? payload}) async {
    const androidDetails = AndroidNotificationDetails('daily_reminder', 'Daily Reminder', importance: Importance.max, priority: Priority.high, styleInformation: BigTextStyleInformation(''));
    const iosDetails = DarwinNotificationDetails();
    await _plugin.show(id, title, body, const NotificationDetails(android: androidDetails, iOS: iosDetails), payload: payload);
  }
}
