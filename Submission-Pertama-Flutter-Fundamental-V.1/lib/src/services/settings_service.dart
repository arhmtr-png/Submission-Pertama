import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const keyDarkTheme = 'keyDarkTheme';
  static const keyDailyReminderActive = 'keyDailyReminderActive';

  Future<bool> isDarkTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyDarkTheme) ?? false;
  }

  Future<void> setDarkTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyDarkTheme, value);
  }

  Future<bool> isDailyReminderActive() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyDailyReminderActive) ?? false;
  }

  Future<void> setDailyReminderActive(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyDailyReminderActive, value);
  }
}
