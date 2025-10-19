import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:submission_pertama/main.dart';
import 'package:submission_pertama/src/providers/restaurant_provider.dart';
import 'package:submission_pertama/src/services/api_service.dart';

void main() {
  testWidgets('Theme toggling keeps text visible', (WidgetTester tester) async {
    // Build app in light mode
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => RestaurantProvider(apiService: ApiService()),
          ),
        ],
        child: const MyApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Find a list title (it may be empty at start due to network). We just ensure AppBar title exists and is visible.
    final titleFinder = find.text('Restaurants');
    expect(titleFinder, findsOneWidget);

    // Now rebuild with dark theme forced by setting platform brightness - simulate dark mode
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(
      () => tester.platformDispatcher.platformBrightnessTestValue =
          Brightness.light,
    );

    // Rebuild app
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => RestaurantProvider(apiService: ApiService()),
          ),
        ],
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();

    // AppBar title should still be visible
    expect(titleFinder, findsOneWidget);
  });
}

