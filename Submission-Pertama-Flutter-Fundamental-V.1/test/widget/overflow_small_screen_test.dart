import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:submission_pertama/src/pages/restaurant_list_page.dart';
import 'package:submission_pertama/src/providers/restaurant_provider.dart';
import 'package:submission_pertama/src/models/restaurant_summary.dart';
import 'package:submission_pertama/src/services/api_service.dart';

class FakeApiService extends ApiService {
  @override
  Future<List<RestaurantSummary>> fetchRestaurantList() async {
    return [
      RestaurantSummary(
        id: '1',
        name:
            'A long restaurant name that should wrap and be ellipsized to avoid overflow',
        pictureId: '',
        city: 'CityName',
        rating: 4.5,
      ),
    ];
  }
}

void main() {
  testWidgets('RestaurantListPage does not overflow on small width', (
    WidgetTester tester,
  ) async {
    final provider = RestaurantProvider(apiService: FakeApiService());
    await provider.fetchRestaurants();

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(size: Size(360, 640)),
          child: ChangeNotifierProvider<RestaurantProvider>.value(
            value: provider,
            child: const RestaurantListPage(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify the restaurant name appears and no overflow occurred during rendering.
    expect(find.textContaining('A long restaurant name'), findsOneWidget);
  });
}

