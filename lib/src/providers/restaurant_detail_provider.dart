import 'package:flutter/foundation.dart';
import '../models/restaurant_detail.dart';
import '../services/api_service.dart';

enum DetailState { idle, loading, hasData, error }

class RestaurantDetailProvider with ChangeNotifier {
  final ApiService apiService;

  RestaurantDetailProvider({required this.apiService});

  DetailState _state = DetailState.idle;
  RestaurantDetail? _detail;
  String _message = '';

  DetailState get state => _state;
  RestaurantDetail? get detail => _detail;
  String get message => _message;

  Future<void> fetchDetail(String id) async {
    _state = DetailState.loading;
    notifyListeners();
    try {
      final d = await apiService.fetchRestaurantDetail(id);
      _detail = d;
      _state = DetailState.hasData;
    } catch (e) {
      _message = e.toString();
      _state = DetailState.error;
    }
    notifyListeners();
  }

  Future<bool> submitReview(String id, String name, String review) async {
    try {
      final ok = await apiService.postReview(
        id: id,
        name: name,
        review: review,
      );
      if (ok) {
        // Refresh detail to get latest reviews
        await fetchDetail(id);
      }
      return ok;
    } catch (_) {
      return false;
    }
  }
}
