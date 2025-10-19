import 'package:flutter/foundation.dart';
import '../services/settings_service.dart';
import '../services/workmanager_wrapper.dart';
import 'package:workmanager/workmanager.dart' show Constraints, NetworkType;

const _dailyTaskName = 'daily_reminder_task_unique';
const _favoritesSyncTaskName = 'favorites_sync_task_unique';

class SettingsProvider with ChangeNotifier {
  final SettingsService service;
  final WorkmanagerWrapper _workmanager;

  SettingsProvider({required this.service, WorkmanagerWrapper? workmanager})
    : _workmanager = workmanager ?? RealWorkmanagerWrapper() {
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
      // Compute next 11:00 occurrence
      final now = DateTime.now();
      DateTime next = DateTime(now.year, now.month, now.day, 11);
      if (now.isAfter(next) || now.isAtSameMomentAs(next)) {
        next = next.add(const Duration(days: 1));
      }
      final initialDelay = next.difference(now);

      // Some platforms may ignore initialDelay on periodic tasks; schedule a one-off
      // task to ensure the first reminder arrives at 11:00, then register a periodic task
      // to continue daily reminders.
      try {
        // Try to call registerOneOffTask if implemented by the wrapper. If it's not
        // implemented, a NoSuchMethodError will be thrown and we fallback below.
        await (_workmanager as dynamic).registerOneOffTask(
          '${_dailyTaskName}_initial',
          'daily_reminder_task',
          initialDelay: initialDelay,
        );
      } on NoSuchMethodError {
        // Fallback: attempt to register periodic with initialDelay
        try {
          await _workmanager.registerPeriodicTask(
            _dailyTaskName,
            'daily_reminder_task',
            frequency: const Duration(hours: 24),
            initialDelay: initialDelay,
            constraints: Constraints(networkType: NetworkType.connected),
          );
        } catch (_) {
          // ignore errors scheduling the first run
        }
      } catch (_) {
        // ignore errors scheduling the first run
      }

      // Register periodic favorites sync task (best-effort)
      await _workmanager.registerPeriodicTask(
        _favoritesSyncTaskName,
        'favorites_sync_task',
        frequency: const Duration(hours: 6),
        constraints: Constraints(networkType: NetworkType.connected),
      );
    } else {
      await _workmanager.cancelByUniqueName(_dailyTaskName);
      // Cancel any possible initial one-off task as well
      await _workmanager.cancelByUniqueName('${_dailyTaskName}_initial');
      await _workmanager.cancelByUniqueName(_favoritesSyncTaskName);
    }
    notifyListeners();
  }
}
