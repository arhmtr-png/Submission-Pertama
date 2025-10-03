import 'dart:io';
// dart:typed_data is provided via flutter services import below; removed explicit import

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class PredictionResult {
  final String label;
  final double confidence;
  PredictionResult(this.label, this.confidence);
}

class MLService {
  MLService._private();
  static final MLService instance = MLService._private();

  static const _modelAsset = 'assets/models/model.tflite';
  static const _labelsAsset = 'assets/labels/labels.txt';

  Uint8List? _modelBytes;
  List<String> _labels = [];
  int _inputWidth = 224;
  int _inputHeight = 224;
  bool _initialized = false;

  Future<void> _loadModel() async {
    if (_initialized) return;
    // Load labels
    final labelsData = await rootBundle.loadString(_labelsAsset);
    _labels = labelsData.split('\n').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();

    // Try remote model download first (URL configured via .env as MODEL_REMOTE_URL)
    try {
      final remote = dotenv.env['MODEL_REMOTE_URL'];
      if (remote != null && remote.isNotEmpty) {
        final uri = Uri.parse(remote);
        final resp = await http.get(uri).timeout(const Duration(seconds: 10));
        if (resp.statusCode == 200 && resp.bodyBytes.isNotEmpty) {
          _modelBytes = resp.bodyBytes;
          debugPrint('MLService: loaded remote model from $remote');
        }
      }
    } catch (e) {
      // ignore and fallback to asset
      debugPrint('MLService: remote model fetch failed: $e');
    }

    // Fallback to bundled asset model
    if (_modelBytes == null) {
      final modelData = await rootBundle.load(_modelAsset);
      _modelBytes = modelData.buffer.asUint8List();
    }

    // Create temporary interpreter to discover input shape
    final tmp = Interpreter.fromBuffer(_modelBytes!);
    final inputShape = tmp.getInputTensor(0).shape; // [1,h,w,3]
    _inputHeight = inputShape.length > 1 ? inputShape[1] : 224;
    _inputWidth = inputShape.length > 2 ? inputShape[2] : 224;
    tmp.close();

    _initialized = true;
  }

  Future<PredictionResult?> predictImage(String imagePath) async {
    if (!_initialized) await _loadModel();
    if (_modelBytes == null) return null;

    final imageBytes = await File(imagePath).readAsBytes();

    final params = _InferenceParams(_modelBytes!, _labels, imageBytes, _inputWidth, _inputHeight);
    final res = await compute<_InferenceParams, Map<String, dynamic>?>(_inferenceIsolate, params);
    if (res == null) return null;
    return PredictionResult(res['label'] as String, res['confidence'] as double);
  }
}

class _InferenceParams {
  final Uint8List modelBytes;
  final List<String> labels;
  final Uint8List imageBytes;
  final int width;
  final int height;
  _InferenceParams(this.modelBytes, this.labels, this.imageBytes, this.width, this.height);
}

Future<Map<String, dynamic>?> _inferenceIsolate(_InferenceParams params) async {
  try {
    final modelBytes = params.modelBytes;
    final labels = params.labels;
    final imgBytes = params.imageBytes;
    final w = params.width;
    final h = params.height;

    final image = img.decodeImage(imgBytes);
    if (image == null) return null;
    final resized = img.copyResize(image, width: w, height: h);

    // Build input as List of List to feed interpreter (shape [1,h,w,3])
    final input = List.generate(1, (_) => List.generate(h, (_) => List.generate(w, (_) => List.filled(3, 0.0))));
    for (int y = 0; y < h; y++) {
      for (int x = 0; x < w; x++) {
        final dynamic pRaw = resized.getPixel(x, y);
        int pix = 0;
        if (pRaw is int) {
          pix = pRaw;
        } else if (pRaw is num) {
          pix = pRaw.toInt();
        } else {
          try {
            pix = (pRaw as dynamic).toInt();
          } catch (_) {
            try {
              pix = (pRaw as dynamic).value as int;
            } catch (_) {
              pix = 0;
            }
          }
        }
        final r = ((pix >> 16) & 0xFF) / 255.0;
        final g = ((pix >> 8) & 0xFF) / 255.0;
        final b = (pix & 0xFF) / 255.0;
        input[0][y][x][0] = r;
        input[0][y][x][1] = g;
        input[0][y][x][2] = b;
      }
    }

    final interpreter = Interpreter.fromBuffer(modelBytes);

    final outTensor = interpreter.getOutputTensor(0);
    final outShape = outTensor.shape; // e.g., [1, N]
    final n = outShape.length > 1 ? outShape[1] : outShape[0];

    final output = List.generate(1, (_) => List.filled(n, 0.0));

    interpreter.run(input, output);

    final probs = output[0];
    int maxIdx = 0;
    double maxVal = probs.isNotEmpty ? probs[0] : 0.0;
    for (var i = 1; i < probs.length; i++) {
      if (probs[i] > maxVal) {
        maxVal = probs[i];
        maxIdx = i;
      }
    }

    final label = (maxIdx < labels.length) ? labels[maxIdx] : 'unknown';
    interpreter.close();
    return {'label': label, 'confidence': maxVal};
  } catch (e) {
    return null;
  }
}
