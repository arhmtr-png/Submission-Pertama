import 'package:flutter/foundation.dart';
import '../models/restaurant_model.dart';
import '../repositories/restaurant_repository.dart';

class FavoriteProvider with ChangeNotifier {
  final RestaurantRepository repository;

  FavoriteProvider({required this.repository}) {
    _loadFavorites();
  }

  List<Restaurant> _favorites = [];
  String _error = '';

  List<Restaurant> get favorites => List.unmodifiable(_favorites);
  String get error => _error;

  Future<void> _loadFavorites() async {
    try {
      final list = await repository.getFavorites();
      _favorites = list;
      _error = '';
    } catch (e) {
      _favorites = [];
      _error = 'Failed to load favorites';
    }
    notifyListeners();
  }

  Future<bool> addFavorite(Restaurant restaurant) async {
    try {
      final ok = await repository.addFavorite(restaurant);
      if (ok) {
        _favorites.add(restaurant);
        notifyListeners();
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
        notifyListeners();
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
}
