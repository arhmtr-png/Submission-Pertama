import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'camera_capture.dart';
import 'camera_preview.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Food Recognizer')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Capture or select an image of food to get started.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text('Take a Picture'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CameraCaptureScreen()),
                );
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.videocam),
              label: const Text('Live Camera'),
              onPressed: () async {
                try {
                  final cameras = await availableCameras();
                  if (!context.mounted) return;
                  if (cameras.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CameraPreviewScreen(camera: cameras.first)),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No cameras found')));
                  }
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to get cameras')));
                }
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.photo_library),
              label: const Text('Select from Gallery'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CameraCaptureScreen(initialFromGallery: true)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
