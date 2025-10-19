import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_pertama/main.dart' as app;
import 'package:submission_pertama/src/services/api_service.dart';
import 'package:submission_pertama/src/providers/restaurant_provider.dart';

// A simple integration test that starts the app, waits for the list, taps the first item,
// and tries to submit a review using the real ApiService. In CI this will run with the
// app on the default test harness.

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('list -> detail -> submit review', (WidgetTester tester) async {
    // Start the app
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => RestaurantProvider(apiService: ApiService()),
          ),
        ],
        child: const app.MyApp(),
      ),
    );

    // Wait for the list to load
    await tester.pumpAndSettle(const Duration(seconds: 4));

    // Find a card and tap it
    final item = find.byType(Card).first;
    expect(item, findsWidgets);
    await tester.tap(item);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Ensure detail loaded by looking for 'Add a Review' text
    expect(find.text('Add a Review'), findsOneWidget);

    // Fill review form
    await tester.enterText(find.byType(TextField).first, 'Tester');
    await tester.enterText(find.byType(TextField).at(1), 'Great place!');
    await tester.ensureVisible(find.text('Submit Review'));
    await tester.tap(find.text('Submit Review'));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // After submission expect snackbar or review present
    expect(find.text('Review submitted').hitTestable(), findsWidgets);
  });
}

