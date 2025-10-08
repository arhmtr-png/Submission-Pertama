import '../models/restaurant_model.dart';

/// Minimal repository interface for restaurants used by providers and tests.
abstract class RestaurantRepository {
  /// Returns a list of restaurants fetched from API or cache.
  Future<List<Restaurant>> getRestaurants();

  /// Favorites-related methods (wrap DatabaseHelper):
  Future<List<Restaurant>> getFavorites();
  Future<bool> addFavorite(Restaurant restaurant);
  Future<bool> removeFavorite(String id);
  Future<bool> isFavorite(String id);
}
