import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:submission_pertama/src/providers/restaurant_provider.dart';

void main() {
  group('RestaurantProvider.search', () {
    final sampleResponse = jsonEncode({
      'restaurants': [
        {'id': '1', 'name': 'Alpha Cafe', 'city': 'Jakarta', 'rating': 4.5},
        {'id': '2', 'name': 'Beta Bistro', 'city': 'Bandung', 'rating': 4.0},
        {'id': '3', 'name': 'Gamma Grill', 'city': 'Jakarta', 'rating': 4.2},
      ]
    });

    test('filters by name and city correctly', () async {
      final mockClient = MockClient((request) async {
        return http.Response(sampleResponse, 200);
      });

      final rp = RestaurantProvider(client: mockClient);
      await rp.fetchAll();

      // search for 'alpha' should return only Alpha Cafe
      await rp.search('alpha');
      expect(rp.state is RestaurantData, true);
      var data = (rp.state as RestaurantData).restaurants;
      expect(data.length, 1);
      expect(data.first['name'], 'Alpha Cafe');

      // search for 'jakarta' should return two entries
      await rp.search('jakarta');
      expect(rp.state is RestaurantData, true);
      data = (rp.state as RestaurantData).restaurants;
      expect(data.length, 2);

      // search for a term not present -> empty
      await rp.search('nonexistent');
      expect(rp.state is RestaurantEmpty, true);
    });

    test('clearing search restores full list', () async {
      final mockClient = MockClient((request) async {
        return http.Response(sampleResponse, 200);
      });

      final rp = RestaurantProvider(client: mockClient);
      await rp.fetchAll();

      // ensure we start with full list
      expect(rp.state is RestaurantData, true);
      var full = (rp.state as RestaurantData).restaurants;
      expect(full.length, 3);

      // perform a filter and then clear
      await rp.search('beta');
      expect(rp.state is RestaurantData, true);
      var filtered = (rp.state as RestaurantData).restaurants;
      expect(filtered.length, 1);

      // clearing should restore
      await rp.search('');
      expect(rp.state is RestaurantData, true);
      final restored = (rp.state as RestaurantData).restaurants;
      expect(restored.length, 3);
    });
  });
}
