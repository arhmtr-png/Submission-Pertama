import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:fundamental/src/pages/restaurant_list_page.dart';
import 'package:fundamental/src/providers/restaurant_provider.dart';
import 'fake_api_service.dart';
import 'package:fundamental/src/pages/restaurant_detail_page.dart';
import 'package:fundamental/src/models/restaurant_summary.dart';
import 'package:fundamental/src/models/restaurant_detail.dart';

void main() {
  testWidgets('List page shows items and navigates to detail', (tester) async {
    final summary = RestaurantSummary(
      id: 'r1',
      name: 'List Resto',
      city: 'City',
      rating: 4.2,
      pictureId: '', // avoid network image
    );

    final detail = RestaurantDetail(
      id: 'r1',
      name: 'List Resto',
      pictureId: 'test-picture',
      description: 'Description',
      city: 'City',
      address: 'Addr',
      rating: 4.2,
      foods: [],
      drinks: [],
      customerReviews: [],
    );

    final fake = FakeApiService(summaries: [summary], detailResponse: detail);

    await tester.pumpWidget(
      ChangeNotifierProvider<RestaurantProvider>(
        create: (_) => RestaurantProvider(apiService: fake),
        child: MaterialApp(
          home: const RestaurantListPage(),
          onGenerateRoute: (settings) {
            if (settings.name == '/detail' && settings.arguments is Map) {
              final args = settings.arguments as Map;
              final id = args['id'] as String?;
              if (id != null) {
                return MaterialPageRoute(builder: (_) => RestaurantDetailPage(id: id, apiService: fake));
              }
            }
            return null;
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('List Resto'), findsOneWidget);

    // Tap the restaurant title (Card/InkWell now used)
    final itemText = find.text('List Resto');
    expect(itemText, findsOneWidget);
    await tester.tap(itemText);
    await tester.pumpAndSettle();

    expect(find.text('Description'), findsOneWidget);
  });

  testWidgets('Detail page submit review updates list', (tester) async {
    final detail = RestaurantDetail(
      id: 'r2',
      name: 'Detail Resto',
      pictureId: 'test-picture',
      description: 'Desc',
      city: 'City',
      address: 'Addr',
      rating: 4.0,
      foods: [],
      drinks: [],
      customerReviews: [],
    );

    final fake = FakeApiService(summaries: [], detailResponse: detail);

    // Pump the detail page directly by creating a provider and pushing the page
    await tester.pumpWidget(
      ChangeNotifierProvider<RestaurantProvider>(
        create: (_) => RestaurantProvider(apiService: fake),
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              return Navigator(
                onGenerateRoute: (_) => MaterialPageRoute(
                  builder: (_) => RestaurantDetailPage(
                    id: detail.id,
                    apiService: fake,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Enter review
    await tester.enterText(find.byType(TextField).at(0), 'Tester');
    await tester.enterText(find.byType(TextField).at(1), 'Nice');
    await tester.ensureVisible(find.text('Submit Review'));
    await tester.tap(find.text('Submit Review'));
    await tester.pumpAndSettle();

    expect(find.text('Tester'), findsWidgets);
    expect(find.text('Nice'), findsWidgets);
  });
}
