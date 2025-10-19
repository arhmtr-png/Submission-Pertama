import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/restaurant_model.dart';
import '../repositories/restaurant_repository.dart';
import '../services/notification_service.dart';

class FavoriteProvider with ChangeNotifier {
  final RestaurantRepository repository;

  final NotificationService? notificationService;

  FavoriteProvider({required this.repository, this.notificationService}) {
    _loadFavorites();
  }

  List<Restaurant> _favorites = [];
  // Maintain a quick lookup set for synchronous favorite checks (used by UI without FutureBuilder)
  final Set<String> _favoriteIds = <String>{};
  String _error = '';

  List<Restaurant> get favorites => List.unmodifiable(_favorites);
  String get error => _error;

  Future<void> _loadFavorites() async {
    // Fast path: try to read cached ids from SharedPreferences to allow
    // immediate UI responsiveness while we fetch the full favorites from DB.
    try {
      try {
        final prefs = await SharedPreferences.getInstance();
        final cached = prefs.getStringList('favorite_ids') ?? [];
        if (cached.isNotEmpty) {
          _favoriteIds
            ..clear()
            ..addAll(cached);
          // We don't have full Restaurant objects yet; notify so UI can
          // render favorite states quickly based on id presence.
          notifyListeners();
        }
      } catch (_) {
        // ignore SharedPreferences failures; we'll still attempt DB load below
      }

      // Then load the authoritative favorites list from repository (DB).
      final list = await repository.getFavorites();
      _favorites = list;
      _favoriteIds
        ..clear()
        ..addAll(list.map((e) => e.id));
      _error = '';

      // Persist authoritative ids back to SharedPreferences for next startup
      try {
        final prefs = await SharedPreferences.getInstance();
        final ids = list.map((e) => e.id).toList();
        await prefs.setStringList('favorite_ids', ids);
      } catch (_) {
        // ignore prefs errors
      }
    } catch (e) {
      // If repository read fails, keep any cached ids we already loaded and
      // present empty favourites list. Don't overwrite cached ids in this case.
      _favorites = [];
      _error = 'Failed to load favorites';
    }
    notifyListeners();
  }

  Future<bool> addFavorite(Restaurant restaurant) async {
    try {
      final ok = await repository.addFavorite(restaurant);
      if (ok) {
        final exists = _favorites.any((r) => r.id == restaurant.id);
        if (!exists) {
          _favorites.add(restaurant);
          _favoriteIds.add(restaurant.id);
          notifyListeners();
          // Persist id to SharedPreferences for quick restore (non-fatal)
          try {
            final prefs = await SharedPreferences.getInstance();
            final ids = prefs.getStringList('favorite_ids') ?? [];
            if (!ids.contains(restaurant.id)) {
              ids.add(restaurant.id);
              await prefs.setStringList('favorite_ids', ids);
            }
          } catch (_) {
            // ignore SharedPreferences errors in tests/environments without the plugin
          }
          // Show a simple immediate notification to confirm action.
          try {
            await NotificationService.showDailyReminder(
              id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
              title: 'Added to favorites',
              body: '${restaurant.name} was added to your favorites',
            );
          } catch (_) {}
        }
      }
      return ok;
    } catch (e) {
      _error = 'Failed to add favorite';
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeFavorite(String id) async {
    try {
      final ok = await repository.removeFavorite(id);
      if (ok) {
        _favorites.removeWhere((r) => r.id == id);
        _favoriteIds.remove(id);
        notifyListeners();
        try {
          final prefs = await SharedPreferences.getInstance();
          final ids = prefs.getStringList('favorite_ids') ?? [];
          if (ids.contains(id)) {
            ids.remove(id);
            await prefs.setStringList('favorite_ids', ids);
          }
        } catch (_) {
          // ignore prefs errors
        }
        try {
          await NotificationService.showDailyReminder(
            id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
            title: 'Removed from favorites',
            body: 'Restaurant removed from favorites',
          );
        } catch (_) {}
      }
      return ok;
    } catch (e) {
      _error = 'Failed to remove favorite';
      notifyListeners();
      return false;
    }
  }

  Future<bool> isFavorite(String id) async {
    try {
      return await repository.isFavorite(id);
    } catch (e) {
      return false;
    }
  }

  /// Synchronous favorite check against the locally cached favorite ids.
  /// This is safe to use in widgets where we want immediate UI state without a FutureBuilder.
  bool isFavoriteSync(String id) => _favoriteIds.contains(id);
}
