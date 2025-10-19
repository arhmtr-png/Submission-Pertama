import 'package:submission_pertama/src/models/restaurant_summary.dart';
import 'package:submission_pertama/src/models/restaurant_detail.dart';
import 'package:submission_pertama/src/services/api_service.dart';

class FakeApiService implements ApiService {
  final List<RestaurantSummary> summaries;
  RestaurantDetail? detailResponse;

  FakeApiService({required this.summaries, this.detailResponse});

  @override
  Future<List<RestaurantSummary>> fetchRestaurantList() async {
    return summaries;
  }

  @override
  Future<RestaurantDetail> fetchRestaurantDetail(String id) async {
    if (detailResponse != null) return detailResponse!;
    throw Exception('Not found');
  }

  @override
  Future<List<RestaurantSummary>> searchRestaurants(String query) async {
    return summaries.where((s) => s.name.contains(query)).toList();
  }

  @override
  Future<bool> postReview({
    required String id,
    required String name,
    required String review,
  }) async {
    if (detailResponse != null) {
      final newReview = CustomerReview(
        name: name,
        review: review,
        date: DateTime.now().toIso8601String(),
      );
      detailResponse = RestaurantDetail(
        id: detailResponse!.id,
        name: detailResponse!.name,
        pictureId: detailResponse!.pictureId,
        description: detailResponse!.description,
        city: detailResponse!.city,
        address: detailResponse!.address,
        rating: detailResponse!.rating,
        foods: detailResponse!.foods,
        drinks: detailResponse!.drinks,
        customerReviews: [...detailResponse!.customerReviews, newReview],
      );
      return true;
    }
    return false;
  }
}

