import 'package:flutter_test/flutter_test.dart';
import 'package:fundamental/src/providers/restaurant_provider.dart';
import 'package:fundamental/src/services/api_service.dart';
import 'package:fundamental/src/models/restaurant_summary.dart';
import 'package:fundamental/src/models/restaurant_detail.dart';

class _FakeApi implements ApiService {
  final List<RestaurantSummary> _list;
  _FakeApi(this._list);

  @override
  Future<List<RestaurantSummary>> fetchRestaurantList() async => _list;

  @override
  Future<List<RestaurantSummary>> searchRestaurants(String query) async {
    return _list
        .where((r) => r.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Not used in this test
  @override
  Future<RestaurantDetail> fetchRestaurantDetail(String id) =>
      throw UnimplementedError();

  @override
  Future<bool> postReview({
    required String id,
    required String name,
    required String review,
  }) => throw UnimplementedError();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('clearing search restores full list', () async {
    final fakeList = [
      RestaurantSummary(
        id: '1',
        name: 'Alpha',
        city: 'C1',
        rating: 4.0,
        pictureId: 'p1',
      ),
      RestaurantSummary(
        id: '2',
        name: 'Beta',
        city: 'C2',
        rating: 4.1,
        pictureId: 'p2',
      ),
    ];
    final api = _FakeApi(fakeList);
    final provider = RestaurantProvider(apiService: api);

    await provider.fetchRestaurants();
    expect(provider.restaurants.length, 2);

    await provider.searchRestaurants('Alpha');
    expect(provider.searchResults.length, 1);

    await provider.searchRestaurants('');
    // after clearing search, provider should re-fetch and restore full list
    expect(provider.restaurants.length, 2);
  });
}
