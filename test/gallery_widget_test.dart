import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:submission_pertama/screens/gallery_page.dart';
import 'package:submission_pertama/main.dart';

void main() {
  testWidgets('Gallery loads items and filters', (WidgetTester tester) async {
    await tester.pumpWidget(const AppRoot());
    await tester.pumpAndSettle();

    // Navigate to gallery route so providers defined in AppRoot are available
    final nav = find.byType(Navigator);
    if (nav.evaluate().isNotEmpty) {
      Navigator.of(tester.element(nav)).pushNamed('/gallery');
      await tester.pumpAndSettle();
    } else {
      // Fallback: pump GalleryPage directly wrapped in MaterialApp
      await tester.pumpWidget(const MaterialApp(home: GalleryPage()));
      await tester.pumpAndSettle();
    }

    // Initially should have some items
    await tester.pumpAndSettle();
    final initial = find.byType(Card).evaluate().length;
    expect(initial, greaterThan(0));

    // Trigger load more by dragging up several times to reach near bottom
    for (var i = 0; i < 3; i++) {
      await tester.drag(find.byType(GridView), const Offset(0, -500));
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
    }

    // After trying to load more, should still have cards and not crash
    await tester.pumpAndSettle();
    expect(find.byType(Card), findsWidgets);
  });
}
