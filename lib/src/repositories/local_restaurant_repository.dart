import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../src/models/restaurant_model.dart';
import '../../src/models/restaurant_detail.dart';
import '../../src/services/api_service.dart';
import '../../src/data/database_helper.dart';
import 'restaurant_repository.dart';

/// Concrete repository that delegates network operations to [ApiService]
/// and favorites persistence to [DatabaseHelper].
class LocalRestaurantRepository implements RestaurantRepository {
  final ApiService apiService;
  final FavoritesDataSource dbHelper;

  LocalRestaurantRepository({ApiService? apiService, FavoritesDataSource? dbHelper})
      : apiService = apiService ?? ApiService(),
        dbHelper = dbHelper ?? DatabaseHelper.instance;

  // Network methods
  @override
  Future<List<Restaurant>> getRestaurants() async {
    try {
      final list = await apiService.fetchRestaurantList();
      // Convert summaries into the lightweight Restaurant model used by the app
      return list
          .map((s) => Restaurant(
                id: s.id,
                name: s.name,
                pictureId: s.pictureId,
                city: s.city,
                rating: s.rating,
              ))
          .toList();
    } catch (e) {
      // Bubble up or return empty list on failure
      return <Restaurant>[];
    }
  }

  Future<RestaurantDetail?> fetchRestaurantDetail(String id) async {
    try {
      return await apiService.fetchRestaurantDetail(id);
    } catch (_) {
      return null;
    }
  }

  Future<List<Restaurant>> searchRestaurants(String query) async {
    try {
      final list = await apiService.searchRestaurants(query);
      return list
          .map((s) => Restaurant(
                id: s.id,
                name: s.name,
                pictureId: s.pictureId,
                city: s.city,
                rating: s.rating,
              ))
          .toList();
    } catch (_) {
      return <Restaurant>[];
    }
  }

  // Favorites methods delegate to DatabaseHelper
  @override
  Future<List<Restaurant>> getFavorites() async {
    try {
      return await dbHelper.getFavorites();
    } catch (_) {
      return <Restaurant>[];
    }
  }

  @override
  Future<bool> addFavorite(Restaurant restaurant) async {
    try {
      return await dbHelper.insertFavorite(restaurant);
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> removeFavorite(String id) async {
    try {
      return await dbHelper.removeFavorite(id);
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> isFavorite(String id) async {
    try {
      return await dbHelper.isFavorite(id);
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> syncFavorites(List<Restaurant> favorites) async {
    try {
      // Simple POST to a demo endpoint. The server should accept JSON array of favorites.
      final uri = Uri.parse('https://example.com/api/syncFavorites');
      final body = favorites.map((f) => f.toJson()).toList();
      final res = await http.post(uri, body: json.encode(body), headers: {'Content-Type': 'application/json'});
      return res.statusCode >= 200 && res.statusCode < 300;
    } catch (_) {
      // Non-fatal in background
      return false;
    }
  }
}
