import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart' show Constraints;
import 'package:fundamental/src/services/settings_service.dart';
import 'package:fundamental/src/providers/settings_provider.dart';
import 'package:fundamental/src/services/workmanager_wrapper.dart';

class _FakeWorkmanager implements WorkmanagerWrapper {
  bool registered = false;
  String? lastName;

  @override
  Future<void> cancelByUniqueName(String uniqueName) async {
    registered = false;
    lastName = null;
  }

  @override
  Future<void> registerPeriodicTask(String uniqueName, String taskName,
      {Duration? frequency, Duration? initialDelay, Constraints? constraints}) async {
    registered = true;
    lastName = uniqueName;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingsProvider scheduling', () {
    late SettingsService service;
    late SettingsProvider provider;

    setUp(() async {
      // Provide mock SharedPreferences before provider is created to avoid platform plugin calls
      SharedPreferences.setMockInitialValues({});
      service = SettingsService();
      final fake = _FakeWorkmanager();
      provider = SettingsProvider(service: service, workmanager: fake);
      // wait for provider to load prefs
      await Future.delayed(const Duration(milliseconds: 10));
    });

    test('toggle daily reminder schedules and cancels without throwing', () async {
      // We don't assert Workmanager internals here (platform-specific).
      // The provider should be resilient and not throw when scheduling/cancelling.
      await provider.setDailyReminderActive(true);
      expect(provider.dailyReminderActive, isTrue);
      await provider.setDailyReminderActive(false);
      expect(provider.dailyReminderActive, isFalse);
    });
  });
}
