import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  // Keep the stored keys unchanged (string values) but expose style-correct
  // constant identifiers to satisfy analyzer.
  static const keyDarkTheme = 'KEY_DARK_THEME';
  static const keyDailyReminderActive = 'KEY_DAILY_REMINDER_ACTIVE';

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
