import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:workmanager/workmanager.dart';
import 'notification_service.dart';
import '../models/restaurant_model.dart';

const String dailyTask = 'daily_reminder_task';

class BackgroundService {
  static void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      try {
        // Simple fetch of restaurant list and pick a random one
        final res = await http.get(Uri.parse('https://restaurant-api.dicoding.dev/list'));
        if (res.statusCode == 200) {
          final data = json.decode(res.body) as Map<String, dynamic>;
          final list = (data['restaurants'] as List<dynamic>).map((e) => Restaurant.fromJson(e as Map<String, dynamic>)).toList();
          if (list.isNotEmpty) {
            final selected = list[DateTime.now().millisecondsSinceEpoch % list.length];
            await NotificationService.showDailyReminder(
              id: 1000,
              title: 'Daily Restaurant Suggestion',
              body: '${selected.name} — ${selected.city}',
              payload: selected.id,
            );
          }
        }
      } catch (_) {
        // Swallow errors — Workmanager should not crash the app
      }
      return Future.value(true);
    });
  }
}
