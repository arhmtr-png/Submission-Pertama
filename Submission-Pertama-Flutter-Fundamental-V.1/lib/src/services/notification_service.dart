import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

typedef NotificationSelectCallback = void Function(String? payload);

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static String? _defaultSoundName;

  /// Initialize notification plugin. Optionally pass [defaultSoundName]
  /// which corresponds to a raw resource under android/app/src/main/res/raw
  /// (without extension) such as `notification_sound` for
  /// `notification_sound.mp3`.
  static Future<void> init({
    NotificationSelectCallback? onSelect,
    String? defaultSoundName,
  }) async {
    _defaultSoundName = defaultSoundName;
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
    // Create a notification channel on Android with optional custom sound.
    if (!kIsWeb) {
      try {
        const channelId = 'daily_reminder';
        const channelName = 'Daily Reminder';
        // Attempt to register a custom sound that may be bundled under
        // android/app/src/main/res/raw/<defaultSoundName>. If provided, set
        // the channel sound to that resource; otherwise channel uses default.
        final androidChannel = AndroidNotificationChannel(
          channelId,
          channelName,
          description: 'Daily reminder and background notifications',
          importance: Importance.max,
          sound: _defaultSoundName != null
              ? RawResourceAndroidNotificationSound(_defaultSoundName!)
              : null,
        );

        // Register the channel with the system (no-op on iOS)
        await _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.createNotificationChannel(androidChannel);
      } catch (_) {
        // Ignore channel creation errors — fallback to defaults.
      }
    }
  }

  static Future<void> showDailyReminder({
    required int id,
    required String title,
    required String body,
    String? payload,
    String? sound,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'daily_reminder',
      'Daily Reminder',
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: const BigTextStyleInformation(''),
      sound: sound != null ? RawResourceAndroidNotificationSound(sound) : null,
    );
    final iosDetails = DarwinNotificationDetails(
      sound: sound != null ? '$sound.aiff' : null,
    );
    await _plugin.show(
      id,
      title,
      body,
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      payload: payload,
    );
  }

  /// Debug helper: show a test notification immediately. Useful during development
  /// to verify that notifications are working on a device/emulator without waiting
  /// for scheduled Workmanager tasks.
  static Future<void> showTestNotification() async {
    await showDailyReminder(
      id: 9999,
      title: 'Test Notification',
      body: 'This is a test notification from the app.',
      payload: 'test',
    );
  }
}
