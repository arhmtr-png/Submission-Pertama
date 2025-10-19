import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart' show Constraints;
import 'package:submission_pertama/src/services/settings_service.dart';
import 'package:submission_pertama/src/providers/settings_provider.dart';
import 'package:submission_pertama/src/services/workmanager_wrapper.dart';

class _FakeWorkmanager implements WorkmanagerWrapper {
  bool registered = false;
  String? lastName;

  @override
  Future<void> cancelByUniqueName(String uniqueName) async {
    registered = false;
    lastName = null;
  }

  @override
  Future<void> registerPeriodicTask(
    String uniqueName,
    String taskName, {
    Duration? frequency,
    Duration? initialDelay,
    Constraints? constraints,
  }) async {
    registered = true;
    lastName = uniqueName;
  }

  @override
  Future<void> registerOneOffTask(
    String uniqueName,
    String taskName, {
    Duration? initialDelay,
  }) async {
    // no-op in tests
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
      // Provide mock SharedPreferences before provider is created
      SharedPreferences.setMockInitialValues({});
      service = SettingsService();
      final fake = _FakeWorkmanager();
      provider = SettingsProvider(service: service, workmanager: fake);
      // wait for provider to load prefs
      await Future.delayed(const Duration(milliseconds: 10));
    });

    test(
      'toggle daily reminder schedules and cancels without throwing',
      () async {
        await provider.setDailyReminderActive(true);
        expect(provider.dailyReminderActive, isTrue);
        await provider.setDailyReminderActive(false);
        expect(provider.dailyReminderActive, isFalse);
      },
    );
  });
}

