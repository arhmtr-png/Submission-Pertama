import 'package:flutter/foundation.dart';
import '../services/settings_service.dart';
import '../services/workmanager_wrapper.dart';
import 'package:workmanager/workmanager.dart' show Constraints, NetworkType;

const _dailyTaskName = 'daily_reminder_task_unique';
const _favoritesSyncTaskName = 'favorites_sync_task_unique';

class SettingsProvider with ChangeNotifier {
  final SettingsService service;
  final WorkmanagerWrapper _workmanager;

  SettingsProvider({required this.service, WorkmanagerWrapper? workmanager}) : _workmanager = workmanager ?? RealWorkmanagerWrapper() {
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
      await _workmanager.registerPeriodicTask(
        _dailyTaskName,
        'daily_reminder_task',
        frequency: const Duration(days: 1),
        initialDelay: initialDelay,
        constraints: Constraints(networkType: NetworkType.connected),
      );
      // Also register a lightweight favorites sync task (periodic)
      await _workmanager.registerPeriodicTask(
        _favoritesSyncTaskName,
        'favorites_sync_task',
        frequency: const Duration(hours: 6),
        constraints: Constraints(networkType: NetworkType.connected),
      );
    } else {
      await _workmanager.cancelByUniqueName(_dailyTaskName);
      await _workmanager.cancelByUniqueName(_favoritesSyncTaskName);
    }
    notifyListeners();
  }
}
