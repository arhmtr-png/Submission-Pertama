import 'package:flutter/foundation.dart';
import '../data/favorite_repository.dart';

class FavoriteProvider with ChangeNotifier {
  final FavoriteRepository repository;

  FavoriteProvider({required this.repository}) {
    _loadFavorites();
  }

  final List<Map<String, dynamic>> _favorites = [];

  List<Map<String, dynamic>> get favorites => List.unmodifiable(_favorites);

  Future<void> _loadFavorites() async {
    final items = await repository.getFavorites();
    _favorites.clear();
    _favorites.addAll(items);
    notifyListeners();
  }

  Future<void> addFavorite(Map<String, dynamic> item) async {
    await repository.insertFavorite(item);
    _favorites.add(item);
    notifyListeners();
  }

  Future<void> removeFavorite(String id) async {
    await repository.removeFavorite(id);
    _favorites.removeWhere((e) => e['id'] == id);
    notifyListeners();
  }

  bool isFavorite(String id) {
    return _favorites.any((e) => e['id'] == id);
  }
}
