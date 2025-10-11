import 'package:flutter/foundation.dart';
import '../models/restaurant_summary.dart';
import '../services/api_service.dart';
import '../utils/result.dart';
import '../utils/error_mapper.dart';

class RestaurantProvider with ChangeNotifier {
  final ApiService apiService;

  RestaurantProvider({required this.apiService});

  Result<List<RestaurantSummary>> _listResult = const Loading();
  List<RestaurantSummary> _searchResults = [];

  Result<List<RestaurantSummary>> get listResult => _listResult;
  List<RestaurantSummary> get searchResults => _searchResults;

  List<RestaurantSummary> get restaurants {
    if (_listResult is Success<List<RestaurantSummary>>) {
      return (_listResult as Success<List<RestaurantSummary>>).data;
    }
    return [];
  }

  String get errorMessage {
    if (_listResult is ErrorResult<List<RestaurantSummary>>) {
      return (_listResult as ErrorResult<List<RestaurantSummary>>).message;
    }
    return '';
  }

  Future<void> fetchRestaurants() async {
    _listResult = const Loading();
    notifyListeners();
    try {
      final result = await apiService.fetchRestaurantList();
      _listResult = Success(result);
      // Clear any previous search result when we refresh the full list
      _searchResults = [];
    } catch (e) {
      _listResult = ErrorResult(friendlyErrorMessage(e));
    }
    notifyListeners();
  }

  Future<void> searchRestaurants(String query) async {
    if (query.isEmpty) {
      // If query is empty, clear previous search results and restore the full list by re-fetching.
      _searchResults = [];
      notifyListeners();
      await fetchRestaurants();
      return;
    }
    _listResult = const Loading();
    notifyListeners();
    try {
      final results = await apiService.searchRestaurants(query);
      _searchResults = results;
      _listResult = Success(results);
    } catch (e) {
      if (e is Exception) {
        _listResult = ErrorResult(e.toString());
      } else {
        _listResult = const ErrorResult('Unknown error');
      }
    }
    notifyListeners();
  }
}
