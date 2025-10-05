import 'package:flutter/foundation.dart';
import '../models/restaurant_summary.dart';
import '../services/api_service.dart';

enum RestaurantState { idle, loading, hasData, error }

class RestaurantProvider with ChangeNotifier {
  final ApiService apiService;

  RestaurantProvider({required this.apiService});

  RestaurantState _state = RestaurantState.idle;
  List<RestaurantSummary> _restaurants = [];
  String _message = '';
  List<RestaurantSummary> _searchResults = [];

  List<RestaurantSummary> get searchResults => _searchResults;

  RestaurantState get state => _state;
  List<RestaurantSummary> get restaurants => _restaurants;
  String get message => _message;

  Future<void> fetchRestaurants() async {
    _state = RestaurantState.loading;
    notifyListeners();
    try {
      final result = await apiService.fetchRestaurantList();
      _restaurants = result;
      _state = RestaurantState.hasData;
    } catch (e) {
      _message = e.toString();
      _state = RestaurantState.error;
    }
    notifyListeners();
  }

  Future<void> searchRestaurants(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }
    _state = RestaurantState.loading;
    notifyListeners();
    try {
      final results = await apiService.searchRestaurants(query);
      _searchResults = results;
      _state = RestaurantState.hasData;
    } catch (e) {
      _message = e.toString();
      _state = RestaurantState.error;
    }
    notifyListeners();
  }
}
