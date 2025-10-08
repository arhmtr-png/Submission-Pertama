import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';
import '../services/settings_service.dart';

const _dailyTaskName = 'daily_reminder_task_unique';

class SettingsProvider with ChangeNotifier {
  final SettingsService service;

  SettingsProvider({required this.service}) {
    _load();
  }

  bool _isDark = false;
  bool _dailyReminderActive = false;

  bool get isDark => _isDark;
  bool get dailyReminderActive => _dailyReminderActive;

  Future<void> _load() async {
    _isDark = await service.isDarkTheme();
    _dailyReminderActive = await service.isDailyReminderActive();
    notifyListeners();
  }

  Future<void> setDarkTheme(bool value) async {
    await service.setDarkTheme(value);
    _isDark = value;
    notifyListeners();
  }

  Future<void> setDailyReminderActive(bool value) async {
    await service.setDailyReminderActive(value);
    _dailyReminderActive = value;
    if (value) {
      // Register periodic task. Workmanager's minimum repeat interval may vary by platform.
      final now = DateTime.now();
      DateTime next = DateTime(now.year, now.month, now.day, 11);
      if (now.isAfter(next) || now.isAtSameMomentAs(next)) {
        next = next.add(const Duration(days: 1));
      }
      final initialDelay = next.difference(now);
      await Workmanager().registerPeriodicTask(
        _dailyTaskName,
        'daily_reminder_task',
        frequency: const Duration(days: 1),
        initialDelay: initialDelay,
        constraints: Constraints(networkType: NetworkType.connected),
      );
    } else {
      await Workmanager().cancelByUniqueName(_dailyTaskName);
    }
    notifyListeners();
    // Schedule or cancel the background Workmanager task. Wrapped in try/catch
    // so tests (where Workmanager isn't available) don't fail.
    try {
      // Compute the delay until the next 11:00 AM occurrence.
      final now = DateTime.now();
      var next = DateTime(now.year, now.month, now.day, 11, 0);
      if (!next.isAfter(now)) {
        next = next.add(const Duration(days: 1));
      }
      final initialDelay = next.difference(now);

      if (value) {
        await Workmanager().registerPeriodicTask(
          'daily_reminder_unique',
          'daily_reminder_task',
          initialDelay: initialDelay,
          frequency: const Duration(days: 1),
        );
      } else {
        await Workmanager().cancelByUniqueName('daily_reminder_unique');
      }
    } catch (_) {
      // If the plugin isn't available (tests or missing platform setup),
      // swallow the error so provider behavior remains testable.
    }
  }
}
