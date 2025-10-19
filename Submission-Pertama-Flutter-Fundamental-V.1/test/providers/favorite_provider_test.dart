import 'package:flutter_test/flutter_test.dart';
import 'package:submission_pertama/src/providers/favorite_provider.dart';
import 'package:submission_pertama/src/models/restaurant_model.dart';
import 'package:submission_pertama/src/repositories/restaurant_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeRepository implements RestaurantRepository {
  final Map<String, Restaurant> _store = {};

  @override
  Future<bool> addFavorite(Restaurant restaurant) async {
    if (_store.containsKey(restaurant.id)) return true; // idempotent
    _store[restaurant.id] = restaurant;
    return true;
  }

  @override
  Future<List<Restaurant>> getFavorites() async {
    return _store.values.toList();
  }

  @override
  Future<bool> isFavorite(String id) async {
    return _store.containsKey(id);
  }

  @override
  Future<bool> removeFavorite(String id) async {
    return _store.remove(id) != null;
  }

  @override
  Future<bool> syncFavorites(List<Restaurant> favorites) async {
    // no-op in tests
    return true;
  }

  // Unused network methods (not implemented for test)
  @override
  Future<List<Restaurant>> getRestaurants() => throw UnimplementedError();
}

class _FailingRepository extends _FakeRepository {
  @override
  Future<bool> addFavorite(Restaurant restaurant) async =>
      throw Exception('DB error');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  group('FavoriteProvider', () {
    test('adds favorite and prevents duplicates', () async {
      final repo = _FakeRepository();
      final provider = FavoriteProvider(repository: repo);
      final r = Restaurant(
        id: '1',
        name: 'A',
        pictureId: 'p1',
        city: 'X',
        rating: 4.0,
      );
      final ok1 = await provider.addFavorite(r);
      expect(ok1, isTrue);
      final ok2 = await provider.addFavorite(r);
      expect(ok2, isTrue);
      // favorites should contain only one item
      expect(provider.favorites.length, 1);
    });

    test('handles DB failure gracefully', () async {
      final repo = _FailingRepository();
      final provider = FavoriteProvider(repository: repo);
      final r = Restaurant(
        id: '2',
        name: 'B',
        pictureId: 'p2',
        city: 'Y',
        rating: 3.5,
      );
      final ok = await provider.addFavorite(r);
      expect(ok, isFalse);
      expect(provider.error, contains('Failed to add'));
    });
  });
}

