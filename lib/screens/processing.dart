import 'dart:io';

import 'package:flutter/material.dart';

import 'results.dart';
import '../services/ml_service.dart';

class ProcessingScreen extends StatefulWidget {
  final File imageFile;
  const ProcessingScreen({super.key, required this.imageFile});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  String? _predictionLabel;
  double _confidence = 0.0;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _runInference();
  }

  Future<void> _runInference() async {
    try {
      setState(() {});
      final result = await MLService.instance.predictImage(widget.imageFile.path);
      if (result != null) {
        setState(() {
          _predictionLabel = result.label;
          _confidence = result.confidence;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ResultsScreen(
              imageFile: widget.imageFile,
              label: _predictionLabel ?? 'Unknown',
              confidence: _confidence,
            ),
          ),
        );
      } else {
        setState(() => _error = true);
      }
    } catch (e) {
      setState(() => _error = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return Scaffold(
        appBar: AppBar(title: const Text('Processing')),
        body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Text('Oops! Something went wrong. Please try again.'), const SizedBox(height: 8), ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Back'))])),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Processing')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text('Processing Image...'),
          ],
        ),
      ),
    );
  }
}
