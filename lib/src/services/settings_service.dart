import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const KEY_DARK_THEME = 'KEY_DARK_THEME';
  static const KEY_DAILY_REMINDER_ACTIVE = 'KEY_DAILY_REMINDER_ACTIVE';

  Future<bool> isDarkTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(KEY_DARK_THEME) ?? false;
  }

  Future<void> setDarkTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(KEY_DARK_THEME, value);
  }

  Future<bool> isDailyReminderActive() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(KEY_DAILY_REMINDER_ACTIVE) ?? false;
  }

  Future<void> setDailyReminderActive(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(KEY_DAILY_REMINDER_ACTIVE, value);
  }
}
