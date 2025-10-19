import 'package:flutter_test/flutter_test.dart';
import 'package:submission_pertama/src/providers/restaurant_provider.dart';
import 'package:submission_pertama/src/services/api_service.dart';
import 'package:submission_pertama/src/models/restaurant_summary.dart';
import 'package:submission_pertama/src/models/restaurant_detail.dart';

class _FailingApi implements ApiService {
  @override
  Future<List<RestaurantSummary>> fetchRestaurantList() =>
      throw Exception('network down');

  @override
  Future<List<RestaurantSummary>> searchRestaurants(String query) =>
      throw Exception('network down');

  @override
  Future<bool> postReview({
    required String id,
    required String name,
    required String review,
  }) => throw UnimplementedError();

  @override
  Future<RestaurantDetail> fetchRestaurantDetail(String id) =>
      throw UnimplementedError();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('searchRestaurants converts API exception to ErrorResult', () async {
    final api = _FailingApi();
    final provider = RestaurantProvider(apiService: api);

    // attempt search; should not throw but set an ErrorResult internally
    await provider.searchRestaurants('kafe');

    // provider.listResult should be an ErrorResult; check via errorMessage getter
    expect(provider.errorMessage, isNotEmpty);
    // SearchResults should stay empty
    expect(provider.searchResults, isEmpty);
  });
}

