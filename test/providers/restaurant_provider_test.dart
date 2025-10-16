import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:submission_pertama/src/providers/restaurant_provider.dart';

void main() {
  test('RestaurantProvider fetchAll success', () async {
    final mockClient = MockClient((request) async {
      final body = jsonEncode({
        'restaurants': [
          {'id': '1', 'name': 'A', 'city': 'X', 'rating': 4.2}
        ]
      });
      return http.Response(body, 200);
    });

    final rp = RestaurantProvider(client: mockClient);
    await rp.fetchAll();
    expect(rp.state is RestaurantData, true);
    final data = (rp.state as RestaurantData).restaurants;
    expect(data.length, 1);
    expect(data.first['name'], 'A');
  });

  test('RestaurantProvider handles failure', () async {
    final mockClient = MockClient((request) async {
      return http.Response('Internal error', 500);
    });
    final rp = RestaurantProvider(client: mockClient);
    await rp.fetchAll();
    expect(rp.state is RestaurantError, true);
  });
}
