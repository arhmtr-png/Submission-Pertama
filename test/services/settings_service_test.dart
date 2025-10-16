import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission_pertama/src/services/settings_service.dart';

void main() {
  group('SettingsService', () {
    test('persists theme selection', () async {
      SharedPreferences.setMockInitialValues({});
      final svc = SettingsService();
      expect(await svc.isDarkTheme(), isFalse);
      await svc.setDarkTheme(true);
      expect(await svc.isDarkTheme(), isTrue);
    });

    test('persists daily reminder flag', () async {
      SharedPreferences.setMockInitialValues({});
      final svc = SettingsService();
      expect(await svc.isDailyReminderActive(), isFalse);
      await svc.setDailyReminderActive(true);
      expect(await svc.isDailyReminderActive(), isTrue);
    });
  });
}
