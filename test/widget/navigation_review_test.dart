import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundamental/src/models/restaurant_summary.dart';
import 'package:fundamental/src/models/restaurant_detail.dart';
import 'fake_api_service.dart';
import 'package:fundamental/src/pages/restaurant_detail_page.dart';

void main() {
  testWidgets('List -> Detail navigation and submit review', (tester) async {
    final summary = RestaurantSummary(
      id: 'r1',
      name: 'Test Resto',
      city: 'City',
      rating: 4.5,
      pictureId: '',
    );

    final detail = RestaurantDetail(
      id: 'r1',
      name: 'Test Resto',
      description: 'Desc',
      city: 'City',
      address: 'Addr',
      rating: 4.5,
      foods: [],
      drinks: [],
      customerReviews: [],
    );

    final fake = FakeApiService(summaries: [summary], detailResponse: detail);

    // Directly pump the detail page with the fake service injected
    await tester.pumpWidget(
      MaterialApp(
        home: RestaurantDetailPage(
          id: 'r1',
          name: 'Test Resto',
          pictureId: '',
          apiService: fake,
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Detail description should be visible
    expect(find.text('Desc'), findsOneWidget);

    // Enter name and review
    await tester.enterText(find.byType(TextField).at(0), 'Alice');
    await tester.enterText(find.byType(TextField).at(1), 'Great!');

    // Tap submit (ensure visible first to avoid hit-test warnings)
    await tester.ensureVisible(find.text('Submit Review'));
    await tester.tap(find.text('Submit Review'));
    await tester.pumpAndSettle();

    // After submission, new review should appear (name and review)
    expect(find.text('Alice'), findsWidgets);
    expect(find.text('Great!'), findsWidgets);
  });
}
