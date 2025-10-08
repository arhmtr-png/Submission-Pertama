import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:workmanager/workmanager.dart';
import 'notification_service.dart';

const String dailyTask = 'daily_reminder_task';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      final res = await http.get(
        Uri.parse('https://restaurant-api.dicoding.dev/list'),
      );
      if (res.statusCode == 200) {
        final data = json.decode(res.body) as Map<String, dynamic>;
        final list = (data['restaurants'] as List<dynamic>)
            .map((e) => e as Map<String, dynamic>)
            .toList();
        if (list.isNotEmpty) {
          final selected =
              list[DateTime.now().millisecondsSinceEpoch % list.length];
          final name = selected['name']?.toString() ?? 'Restaurant';
          final city = selected['city']?.toString() ?? '';
          final id = selected['id']?.toString();
          await NotificationService.showDailyReminder(
            id: 1000,
            title: 'Daily Restaurant Suggestion',
            body: city.isNotEmpty ? '$name — $city' : name,
            payload: id,
          );
        }
      }
    } catch (_) {
      // Swallow errors — Workmanager should not crash the app
    }
    return Future.value(true);
  });
}
