import 'package:flutter_test/flutter_test.dart';
import 'package:fundamental/src/providers/restaurant_provider.dart';
import 'package:fundamental/src/providers/restaurant_detail_provider.dart';
import 'widget/fake_api_service.dart';
import 'package:fundamental/src/models/restaurant_detail.dart';
import 'package:fundamental/src/models/restaurant_summary.dart';

void main() {
  test('RestaurantProvider.fetchRestaurants uses ApiService', () async {
    final summary = RestaurantSummary(
      id: 'r1',
      name: 'Resto',
      city: 'City',
      rating: 4.0,
      pictureId: '',
    );
    final fake = FakeApiService(summaries: [summary]);

    final provider = RestaurantProvider(apiService: fake);
    await provider.fetchRestaurants();

    expect(provider.restaurants.length, 1);
    expect(provider.restaurants.first.name, 'Resto');
  });

  test('RestaurantDetailProvider.fetchDetail and submitReview', () async {
    final summary = RestaurantSummary(
      id: 'r1',
      name: 'Resto',
      city: 'City',
      rating: 4.0,
      pictureId: '',
    );

    final fakeDetail = FakeApiService(summaries: [summary]);

    // Create a RestaurantDetail instance
    final detail = RestaurantDetail(
      id: 'r1',
      name: 'Resto',
      description: 'Desc',
      city: 'City',
      address: 'Addr',
      rating: 4.0,
      foods: [],
      drinks: [],
      customerReviews: [],
    );

    fakeDetail.detailResponse = detail;

    final detailProvider = RestaurantDetailProvider(apiService: fakeDetail);
    await detailProvider.fetchDetail('r1');
    expect(detailProvider.detail?.name, 'Resto');

    final ok = await detailProvider.submitReview('r1', 'Alice', 'Great');
    expect(ok, isTrue);
    // After submission, detail should be refreshed and contain the new review
    expect(detailProvider.detail?.customerReviews, isNotEmpty);
    expect(detailProvider.detail?.customerReviews.last.name, 'Alice');
  });
}
