import 'package:flutter_test/flutter_test.dart';
import 'package:submission_pertama/src/models/restaurant_summary.dart';
import 'package:submission_pertama/src/models/restaurant_detail.dart';

void main() {
  test('RestaurantSummary.fromJson parses correctly', () {
    final json = {
      'id': 'r1',
      'name': 'Test Resto',
      'city': 'Test City',
      'rating': 4.5,
      'pictureId': 'pic123',
    };

    final s = RestaurantSummary.fromJson(json);

    expect(s.id, 'r1');
    expect(s.name, 'Test Resto');
    expect(s.city, 'Test City');
    expect(s.rating, 4.5);
    expect(s.pictureId, 'pic123');
  });

  test('RestaurantDetail.fromJson parses menus and reviews', () {
    final json = {
      'id': 'r1',
      'name': 'Detail Resto',
      'description': 'A nice place',
      'city': 'City',
      'address': '123 Street',
      'rating': 4.0,
      'menus': {
        'foods': [
          {'name': 'Nasi Goreng'},
          {'name': 'Mie Goreng'},
        ],
        'drinks': [
          {'name': 'Teh'},
          {'name': 'Kopi'},
        ],
      },
      'customerReviews': [
        {'name': 'Alice', 'review': 'Great!', 'date': '2023-01-01'},
        {'name': 'Bob', 'review': 'Okay', 'date': '2023-01-02'},
      ],
    };

    final d = RestaurantDetail.fromJson(json);

    expect(d.id, 'r1');
    expect(d.name, 'Detail Resto');
    expect(d.foods.length, 2);
    expect(d.drinks.length, 2);
    expect(d.customerReviews.length, 2);
    expect(d.customerReviews.first.name, 'Alice');
  });
}

