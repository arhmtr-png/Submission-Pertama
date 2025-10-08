import 'package:flutter/foundation.dart';
import '../services/settings_service.dart';

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
    notifyListeners();
  }
}
