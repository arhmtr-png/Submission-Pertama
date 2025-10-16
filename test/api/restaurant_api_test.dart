import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('Restaurant API parsing', () {
    test('parses restaurant list on HTTP 200', () async {
      final mockClient = MockClient((request) async {
        final body = json.encode({
          'restaurants': [
            {'id': 'r1', 'name': 'Test Resto', 'city': 'Test City'},
          ],
        });
        return http.Response(body, 200);
      });

      final res = await mockClient.get(
        Uri.parse('https://restaurant-api.dicoding.dev/list'),
      );
      expect(res.statusCode, 200);
      final data = json.decode(res.body) as Map<String, dynamic>;
      final list = (data['restaurants'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList();
      expect(list, isNotEmpty);
      expect(list.first['id'], 'r1');
      expect(list.first['name'], 'Test Resto');
    });

    test('handles non-200 responses gracefully', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Server error', 500);
      });

      final res = await mockClient.get(
        Uri.parse('https://restaurant-api.dicoding.dev/list'),
      );
      expect(res.statusCode, isNot(200));
      // Attempt to decode should throw for non-JSON; validate we don't silently succeed
      expect(() => json.decode(res.body), throwsA(isA<FormatException>()));
    });
  });
}
