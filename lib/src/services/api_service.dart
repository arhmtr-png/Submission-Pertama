import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/restaurant_summary.dart';
import '../models/restaurant_detail.dart';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';

  Future<List<RestaurantSummary>> fetchRestaurantList() async {
    final uri = Uri.parse('$_baseUrl/list');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final restaurants = data['restaurants'] as List<dynamic>;
      return restaurants
          .map((e) => RestaurantSummary.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load restaurant list');
    }
  }

  Future<RestaurantDetail> fetchRestaurantDetail(String id) async {
    final uri = Uri.parse('$_baseUrl/detail/$id');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final detail = data['restaurant'] as Map<String, dynamic>;
      return RestaurantDetail.fromJson(detail);
    } else {
      throw Exception('Failed to load restaurant detail');
    }
  }

  Future<List<RestaurantSummary>> searchRestaurants(String query) async {
    final uri = Uri.parse('$_baseUrl/search?q=$query');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final restaurants = data['restaurants'] as List<dynamic>;
      return restaurants
          .map((e) => RestaurantSummary.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to search restaurants');
    }
  }

  Future<bool> postReview({
    required String id,
    required String name,
    required String review,
  }) async {
    final uri = Uri.parse('$_baseUrl/review');
    final payload = json.encode({'id': id, 'name': name, 'review': review});
    final response = await http.post(
      uri,
      body: payload,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
