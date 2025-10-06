import 'package:flutter/foundation.dart';
import '../models/restaurant_detail.dart';
import '../services/api_service.dart';
import '../utils/result.dart';
import '../utils/error_mapper.dart';

class RestaurantDetailProvider with ChangeNotifier {
  final ApiService apiService;

  RestaurantDetailProvider({required this.apiService});

  Result<RestaurantDetail> _detailResult = const Loading();
  bool _submitting = false;

  bool get submitting => _submitting;

  Result<RestaurantDetail> get detailResult => _detailResult;

  RestaurantDetail? get detail {
    if (_detailResult is Success<RestaurantDetail>) {
      return (_detailResult as Success<RestaurantDetail>).data;
    }
    return null;
  }

  String get errorMessage {
    if (_detailResult is ErrorResult<RestaurantDetail>) {
      return (_detailResult as ErrorResult<RestaurantDetail>).message;
    }
    return '';
  }

  Future<void> fetchDetail(String id) async {
    _detailResult = const Loading();
    notifyListeners();
    try {
      final d = await apiService.fetchRestaurantDetail(id);
      _detailResult = Success(d);
    } catch (e) {
      _detailResult = ErrorResult(friendlyErrorMessage(e));
    }
    notifyListeners();
  }

  Future<bool> submitReview(String id, String name, String review) async {
    _submitting = true;
    notifyListeners();
    try {
      final ok = await apiService.postReview(
        id: id,
        name: name,
        review: review,
      );
      if (ok) {
        await fetchDetail(id);
      }
      return ok;
    } catch (e) {
      return false;
    } finally {
      _submitting = false;
      notifyListeners();
    }
  }
}
