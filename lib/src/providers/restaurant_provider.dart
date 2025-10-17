import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

typedef HttpClient = http.Client;

// Sealed-like state classes for restaurant list
abstract class RestaurantState {}

class RestaurantLoading extends RestaurantState {}

class RestaurantData extends RestaurantState {
  final List<Map<String, dynamic>> restaurants;
  RestaurantData(this.restaurants);
}

class RestaurantEmpty extends RestaurantState {}

class RestaurantError extends RestaurantState {
  final String message;
  RestaurantError(this.message);
}

class RestaurantProvider with ChangeNotifier {
  RestaurantState _state = RestaurantLoading();
  RestaurantState get state => _state;

  final HttpClient httpClient;

  RestaurantProvider({HttpClient? client}) : httpClient = client ?? HttpClient();

  List<Map<String, dynamic>> _all = [];

  Future<void> fetchAll() async {
    _state = RestaurantLoading();
    notifyListeners();
    try {
      final res = await httpClient.get(
        Uri.parse('https://restaurant-api.dicoding.dev/list'),
      );
      if (res.statusCode == 200) {
        final json = jsonDecode(res.body) as Map<String, dynamic>;
        final list = (json['restaurants'] as List<dynamic>)
            .map((e) => e as Map<String, dynamic>)
            .toList();
        _all = list;
        if (list.isEmpty) {
          _state = RestaurantEmpty();
        } else {
          _state = RestaurantData(list);
        }
      } else {
        _state = RestaurantError(
          'Could not load restaurants. Please check your connection and try again.',
        );
      }
    } catch (e) {
      _state = RestaurantError(
        'Could not load restaurants. Please check your internet connection and try again.',
      );
    }
    notifyListeners();
  }

  Future<void> search(String query) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      // restore full list
      if (_all.isEmpty) {
        await fetchAll();
      } else {
        _state = RestaurantData(List.from(_all));
        notifyListeners();
      }
      return;
    }
    final filtered = _all.where((r) {
      final name = (r['name']?.toString() ?? '').toLowerCase();
      final city = (r['city']?.toString() ?? '').toLowerCase();
      return name.contains(q) || city.contains(q);
    }).toList();
    if (filtered.isEmpty) {
      _state = RestaurantEmpty();
    } else {
      _state = RestaurantData(filtered);
    }
    notifyListeners();
  }
}
