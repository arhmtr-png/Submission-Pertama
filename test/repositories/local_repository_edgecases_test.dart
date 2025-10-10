import 'package:flutter_test/flutter_test.dart';
import 'package:fundamental/src/repositories/local_restaurant_repository.dart';
import 'package:fundamental/src/models/restaurant_model.dart';
import 'package:fundamental/src/services/api_service.dart';
import 'package:fundamental/src/data/database_helper.dart';
import 'package:fundamental/src/models/restaurant_summary.dart';
import 'package:fundamental/src/models/restaurant_detail.dart';


class FakeApiServiceEmpty implements ApiService {
  @override
  Future<List<RestaurantSummary>> fetchRestaurantList() async => <RestaurantSummary>[];

  @override
  Future<RestaurantDetail> fetchRestaurantDetail(String id) async => throw Exception('Not implemented');

  @override
  Future<List<RestaurantSummary>> searchRestaurants(String query) async => <RestaurantSummary>[];

  @override
  Future<bool> postReview({required String id, required String name, required String review}) async => true;
}

class FakeApiServiceError implements ApiService {
  @override
  Future<List<RestaurantSummary>> fetchRestaurantList() async => throw Exception('Network error');

  @override
  Future<RestaurantDetail> fetchRestaurantDetail(String id) async => throw Exception('Network error');

  @override
  Future<List<RestaurantSummary>> searchRestaurants(String query) async => throw Exception('Network error');

  @override
  Future<bool> postReview({required String id, required String name, required String review}) async => throw Exception('Network error');
}

/// Fake DB helper that implements the favorites methods used by the repository.
class FakeDbThrows implements FavoritesDataSource {
  Future<bool> insertFavorite(Restaurant restaurant) async {
    throw Exception('DB write failed');
  }

  Future<bool> removeFavorite(String id) async {
    throw Exception('DB delete failed');
  }

  Future<bool> isFavorite(String id) async {
    return false;
  }

  Future<List<Restaurant>> getFavorites() async => <Restaurant>[];
}

void main() {
  group('LocalRestaurantRepository edge cases', () {
    test('empty API response returns empty list', () async {
      final repo = LocalRestaurantRepository(apiService: FakeApiServiceEmpty(), dbHelper: DatabaseHelper.instance);
      final list = await repo.getRestaurants();
      expect(list, isEmpty);
    });

    test('network error returns safe empty list', () async {
      final repo = LocalRestaurantRepository(apiService: FakeApiServiceError(), dbHelper: DatabaseHelper.instance);
      final list = await repo.getRestaurants();
      expect(list, isEmpty);
    });

    test('db write failures return false on add/remove', () async {
      final repo = LocalRestaurantRepository(apiService: FakeApiServiceEmpty(), dbHelper: FakeDbThrows());
      final r = Restaurant(id: 'x', name: 'X', pictureId: '', city: '', rating: 0.0);
      final add = await repo.addFavorite(r);
      expect(add, isFalse);
      final remove = await repo.removeFavorite('x');
      expect(remove, isFalse);
    });
  });
}
