import 'package:flutter/foundation.dart';
import '../models/restaurant_model.dart';
import '../repositories/restaurant_repository.dart';
import '../repositories/exceptions.dart';

enum ResultState { Loading, HasData, NoData, Error }

class RestaurantListProvider with ChangeNotifier {
  final RestaurantRepository repository;

  RestaurantListProvider({required this.repository});

  ResultState _state = ResultState.Loading;
  List<Restaurant> _restaurants = [];
  String _message = '';

  ResultState get state => _state;
  List<Restaurant> get restaurants => _restaurants;
  String get message => _message;

  Future<void> fetchRestaurants() async {
    _state = ResultState.Loading;
    notifyListeners();
    try {
      final list = await repository.getRestaurants();
      if (list.isEmpty) {
        _state = ResultState.NoData;
        _message = 'No restaurants available.';
        _restaurants = [];
      } else {
        _state = ResultState.HasData;
        _restaurants = list;
        _message = '';
      }
    } on NoConnectionException catch (e) {
      _state = ResultState.Error;
      _message = e.message;
      _restaurants = [];
    } on FetchDataException catch (e) {
      _state = ResultState.Error;
      _message = e.message;
      _restaurants = [];
    } catch (e) {
      _state = ResultState.Error;
      _message = 'Something went wrong';
      _restaurants = [];
    }
    notifyListeners();
  }
}
