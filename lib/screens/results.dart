import 'dart:io';

import 'package:flutter/material.dart';

import '../services/mealdb_service.dart';
import '../services/gemini_service.dart';

class ResultsScreen extends StatefulWidget {
  final File imageFile;
  final String label;
  final double confidence;
  const ResultsScreen({super.key, required this.imageFile, required this.label, required this.confidence});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  Map<String, dynamic>? _recipe;
  Map<String, dynamic>? _nutrition;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    setState(() => _loading = true);
    try {
      _recipe = await MealDBService.searchMealByName(widget.label);
      _nutrition = await GeminiService.getNutrition(widget.label);
    } catch (e) {
      // ignore errors for now
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prediction Result')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.file(widget.imageFile, height: 200)),
            const SizedBox(height: 12),
            Text(widget.label, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: widget.confidence),
            const SizedBox(height: 8),
            Text('Confidence: ${(widget.confidence * 100).toStringAsFixed(1)}%'),
            const SizedBox(height: 16),
            if (_loading) const Center(child: CircularProgressIndicator()) else ...[
              const Text('Recipe', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (_recipe != null) ...[
                if (_recipe!['strMealThumb'] != null) Center(child: Image.network(_recipe!['strMealThumb'], height: 180)),
                const SizedBox(height: 8),
                Text(_recipe!['strMeal'] ?? widget.label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Ingredients:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                ..._buildIngredients(_recipe!),
                const SizedBox(height: 8),
                const Text('Instructions:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(_recipe!['strInstructions'] ?? 'No instructions found'),
              ] else const Text('No recipe found.'),
              const SizedBox(height: 12),
              const Text('Nutrition', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (_nutrition != null) ..._nutrition!.entries.map((e) => Text('${e.key}: ${e.value}')).toList() else const Text('No nutrition data.'),
            ]
          ],
        ),
      ),
    );
  }

  List<Widget> _buildIngredients(Map<String, dynamic> meal) {
    final List<Widget> items = [];
    for (int i = 1; i <= 20; i++) {
      final ing = meal['strIngredient$i'];
      final measure = meal['strMeasure$i'];
      if (ing != null && (ing as String).trim().isNotEmpty) {
        items.add(Text('• ${measure ?? ''} ${ing}'));
      }
    }
    return items;
  }
}
