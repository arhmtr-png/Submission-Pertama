import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fundamental/src/services/settings_service.dart';

void main() {
  group('SettingsService persistence', () {
    final svc = SettingsService();

    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('dark theme flag persists', () async {
      await svc.setDarkTheme(true);
      final v = await svc.isDarkTheme();
      expect(v, isTrue);
    });

    test('daily reminder flag persists', () async {
      await svc.setDailyReminderActive(true);
      final v = await svc.isDailyReminderActive();
      expect(v, isTrue);
    });
  });
}
