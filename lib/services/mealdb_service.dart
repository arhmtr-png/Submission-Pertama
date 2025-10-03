import 'dart:convert';
import 'package:http/http.dart' as http;

class MealDBService {
  static const _base = 'https://www.themealdb.com/api/json/v1/1';

  static Future<Map<String, dynamic>?> searchMealByName(String name) async {
    final uri = Uri.parse('$_base/search.php?s=${Uri.encodeComponent(name)}');
    final res = await http.get(uri);
    if (res.statusCode != 200) return null;
    final map = jsonDecode(res.body) as Map<String, dynamic>;
    if (map['meals'] == null) return null;
    return (map['meals'] as List).first as Map<String, dynamic>;
  }
}
