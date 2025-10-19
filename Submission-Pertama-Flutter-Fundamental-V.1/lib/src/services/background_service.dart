import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:workmanager/workmanager.dart';
import 'notification_service.dart';
import '../data/database_helper.dart';
import '../repositories/local_restaurant_repository.dart';
import '../models/restaurant_model.dart';

const String dailyTask = 'daily_reminder_task';
const String favoritesSyncTask = 'favorites_sync_task';

@pragma('vm:entry-point')
void callbackDispatcherImpl() {
  Workmanager().executeTask((task, inputData) async {
    try {
      if (task == dailyTask) {
        // Simple fetch of restaurant list and pick a random one
        final res = await http.get(
          Uri.parse('https://restaurant-api.dicoding.dev/list'),
        );
        if (res.statusCode == 200) {
          final data = json.decode(res.body) as Map<String, dynamic>;
          final list = (data['restaurants'] as List<dynamic>)
              .map((e) => Restaurant.fromJson(e as Map<String, dynamic>))
              .toList();
          if (list.isNotEmpty) {
            final selected =
                list[DateTime.now().millisecondsSinceEpoch % list.length];
            await NotificationService.showDailyReminder(
              id: 1000,
              title: 'Daily Restaurant Suggestion',
              body: '${selected.name} — ${selected.city}',
              payload: selected.id,
            );
          }
        }
      } else if (task == favoritesSyncTask) {
        // Background sync: read favorites from local DB and send to server (best-effort).
        try {
          final db = DatabaseHelper.instance;
          final favs = await db.getFavorites();
          if (favs.isNotEmpty) {
            final repo = LocalRestaurantRepository(dbHelper: db);
            final ok = await repo.syncFavorites(favs);
            await NotificationService.showDailyReminder(
              id: 2000,
              title: ok ? 'Favorites Synced' : 'Favorites Sync Failed',
              body: ok
                  ? 'Synced ${favs.length} favorite(s).'
                  : 'Could not sync favorites in background.',
            );
          }
        } catch (_) {
          // ignore errors in background
        }
      }
    } catch (_) {
      // Swallow errors — Workmanager should not crash the app
    }
    return Future.value(true);
  });
}

class BackgroundService {
  /// Backwards-compatible wrapper to expose the callback to the initializer.
  ///
  /// Use `runNow()` from debug code to execute the same logic on the main
  /// isolate without going through Workmanager. This avoids calling the
  /// top-level entrypoint via a recursive static method.
  static void runNow() => callbackDispatcherImpl();
}
