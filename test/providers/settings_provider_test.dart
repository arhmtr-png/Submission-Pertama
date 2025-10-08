import 'package:flutter_test/flutter_test.dart';
import 'package:submission_pertama/src/providers/settings_provider.dart';
import 'package:submission_pertama/src/services/settings_service.dart';

class _FakeService extends SettingsService {
  bool _dark = false;
  bool _daily = false;

  @override
  Future<bool> isDarkTheme() async => _dark;

  @override
  Future<void> setDarkTheme(bool value) async => _dark = value;

  @override
  Future<bool> isDailyReminderActive() async => _daily;

  @override
  Future<void> setDailyReminderActive(bool value) async => _daily = value;
}

void main() {
  group('SettingsProvider', () {
    late SettingsProvider provider;
    late _FakeService service;

    setUp(() {
      service = _FakeService();
      provider = SettingsProvider(service: service);
    });

    test('initial state loads from service', () async {
      // wait for _load
      await Future.delayed(const Duration(milliseconds: 50));
      expect(provider.isDark, isFalse);
      expect(provider.dailyReminderActive, isFalse);
    });

    test('setDarkTheme toggles and persists', () async {
      await provider.setDarkTheme(true);
      expect(provider.isDark, isTrue);
    });

    test('setDailyReminderActive toggles and persists', () async {
      await provider.setDailyReminderActive(true);
      expect(provider.dailyReminderActive, isTrue);
    });
  });
}
