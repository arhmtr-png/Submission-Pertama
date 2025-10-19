import 'package:flutter_test/flutter_test.dart';
import 'package:fundamental/src/providers/favorite_provider.dart';
import 'package:fundamental/src/models/restaurant_model.dart';
import 'package:fundamental/src/repositories/restaurant_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Notifications tests are skipped in this suite because plugin initialization requires a
// real platform. Use device-level manual testing or integration tests on an emulator/device.

class _FakeRepository implements RestaurantRepository {
  final Map<String, Restaurant> _store = {};

  @override
  Future<bool> addFavorite(Restaurant restaurant) async {
    if (_store.containsKey(restaurant.id)) return true;
    _store[restaurant.id] = restaurant;
    return true;
  }

  @override
  Future<List<Restaurant>> getFavorites() async => _store.values.toList();

  @override
  Future<bool> isFavorite(String id) async => _store.containsKey(id);

  @override
  Future<bool> removeFavorite(String id) async => _store.remove(id) != null;

  @override
  Future<bool> syncFavorites(List<Restaurant> favorites) async => true;

  @override
  Future<List<Restaurant>> getRestaurants() => throw UnimplementedError();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  test('favorite toggle persistence (simulated)', () async {
    final repo = _FakeRepository();
    final provider = FavoriteProvider(repository: repo);
    final r = Restaurant(
      id: 'integration-1',
      name: 'Cafe',
      pictureId: 'p1',
      city: 'City',
      rating: 4.2,
    );

    final ok = await provider.addFavorite(r);
    expect(ok, isTrue);
    // Simulate app restart by creating a new provider that loads from the same repo
    final provider2 = FavoriteProvider(repository: repo);
    // allow provider2 to load
    await Future.delayed(const Duration(milliseconds: 100));
    expect(provider2.favorites.any((f) => f.id == r.id), isTrue);
  });

  // Skipping notification platform test here because flutter_local_notifications requires
  // a platform implementation that is not available in the unit test environment.
}
