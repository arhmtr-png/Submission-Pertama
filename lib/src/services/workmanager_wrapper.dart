import 'package:workmanager/workmanager.dart';

/// A small wrapper around the Workmanager API so we can inject a fake in tests.
abstract class WorkmanagerWrapper {
  Future<void> registerPeriodicTask(String uniqueName, String taskName,
      {Duration? frequency, Duration? initialDelay, Constraints? constraints});

  Future<void> cancelByUniqueName(String uniqueName);
}

class RealWorkmanagerWrapper implements WorkmanagerWrapper {
  @override
  Future<void> registerPeriodicTask(String uniqueName, String taskName,
      {Duration? frequency, Duration? initialDelay, Constraints? constraints}) {
    return Workmanager().registerPeriodicTask(uniqueName, taskName,
        frequency: frequency ?? const Duration(days: 1), initialDelay: initialDelay, constraints: constraints);
  }

  @override
  Future<void> cancelByUniqueName(String uniqueName) {
    return Workmanager().cancelByUniqueName(uniqueName);
  }
}
