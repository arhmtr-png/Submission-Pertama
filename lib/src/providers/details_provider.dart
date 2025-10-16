import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Lightweight provider responsible for loading and exposing a single
/// restaurant detail. It accepts either a pre-loaded [data] map or an
/// [id] to fetch from the remote API. No FutureBuilder required — the
/// provider manages loading/error state and notifies listeners.
class DetailsProvider with ChangeNotifier {
  Map<String, dynamic>? _data;
  bool _loading = false;
  String? _error;

  Map<String, dynamic>? get data => _data;
  bool get loading => _loading;
  String? get error => _error;

  DetailsProvider({Map<String, dynamic>? data, String? id}) {
    if (data != null) {
      _data = data;
      _loading = false;
      notifyListeners();
    } else if (id != null) {
      _fetchById(id);
    }
  }

  Future<void> _fetchById(String id) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await http.get(
        Uri.parse('https://restaurant-api.dicoding.dev/detail/$id'),
      );
      if (res.statusCode == 200) {
        final json = jsonDecode(res.body) as Map<String, dynamic>;
        _data = json['restaurant'] as Map<String, dynamic>?;
      } else {
        _error = 'Failed to load details (${res.statusCode})';
      }
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }
}
