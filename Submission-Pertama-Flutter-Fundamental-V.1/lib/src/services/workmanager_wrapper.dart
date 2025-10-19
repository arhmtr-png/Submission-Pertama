import 'package:workmanager/workmanager.dart';

/// A small wrapper around the Workmanager API so we can inject a fake in tests.
abstract class WorkmanagerWrapper {
  Future<void> registerPeriodicTask(
    String uniqueName,
    String taskName, {
    Duration? frequency,
    Duration? initialDelay,
    Constraints? constraints,
  });

  /// Optional: register a one-off task with an initial delay. Implementations
  /// that do not support this may throw [NoSuchMethodError].
  Future<void> registerOneOffTask(
    String uniqueName,
    String taskName, {
    Duration? initialDelay,
  });

  Future<void> cancelByUniqueName(String uniqueName);
}

class RealWorkmanagerWrapper implements WorkmanagerWrapper {
  @override
  Future<void> registerPeriodicTask(
    String uniqueName,
    String taskName, {
    Duration? frequency,
    Duration? initialDelay,
    Constraints? constraints,
  }) {
    return Workmanager().registerPeriodicTask(
      uniqueName,
      taskName,
      frequency: frequency ?? const Duration(hours: 24),
      initialDelay: initialDelay,
      constraints: constraints,
    );
  }

  @override
  Future<void> registerOneOffTask(
    String uniqueName,
    String taskName, {
    Duration? initialDelay,
  }) {
    return Workmanager().registerOneOffTask(
      uniqueName,
      taskName,
      initialDelay: initialDelay,
    );
  }

  @override
  Future<void> cancelByUniqueName(String uniqueName) {
    return Workmanager().cancelByUniqueName(uniqueName);
  }
}
