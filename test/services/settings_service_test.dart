import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fundamental/src/services/settings_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingsService', () {
    late SettingsService service;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      service = SettingsService();
    });

    test('default theme is false (light)', () async {
      final isDark = await service.isDarkTheme();
      expect(isDark, isFalse);
    });

    test('set and get dark theme persist', () async {
      await service.setDarkTheme(true);
      final isDark = await service.isDarkTheme();
      expect(isDark, isTrue);
    });

    test('default daily reminder is false', () async {
      final active = await service.isDailyReminderActive();
      expect(active, isFalse);
    });

    test('set and get daily reminder persist', () async {
      await service.setDailyReminderActive(true);
      final active = await service.isDailyReminderActive();
      expect(active, isTrue);
    });
  });
}
