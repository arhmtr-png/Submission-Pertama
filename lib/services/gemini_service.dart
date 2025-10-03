import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  /// GEMINI_API_URL should be the full endpoint that accepts a POST or GET
  /// request for nutrition by food name. GEMINI_API_KEY should be provided in .env.
  static Future<Map<String, dynamic>?> getNutrition(String foodName) async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    final apiUrl = dotenv.env['GEMINI_API_URL'];
    if (apiKey == null || apiKey.isEmpty || apiUrl == null || apiUrl.isEmpty) return null;

    try {
      final uri = Uri.parse(apiUrl);
      final resp = await http.post(uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apiKey',
          },
          body: jsonEncode({'query': foodName}));

      if (resp.statusCode != 200) return null;
      final map = jsonDecode(resp.body) as Map<String, dynamic>;

      // Expecting a response with nutrition fields; adapt parsing as needed.
      return {
        'calories': map['calories'] ?? map['calorie'] ?? map['kcal'],
        'protein_g': map['protein_g'] ?? map['protein'],
        'fat_g': map['fat_g'] ?? map['fat'],
        'carbs_g': map['carbs_g'] ?? map['carbs'] ?? map['carbohydrates'],
        'fiber_g': map['fiber_g'] ?? map['fiber'],
      };
    } catch (e) {
      return null;
    }
  }
}
