import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

import 'processing.dart';

class CameraCaptureScreen extends StatefulWidget {
  final bool initialFromGallery;
  const CameraCaptureScreen({super.key, this.initialFromGallery = false});

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.initialFromGallery) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _pickImage(ImageSource.gallery));
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? picked = await _picker.pickImage(source: source, maxWidth: 1024, maxHeight: 1024);
    if (picked == null) return;
    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: picked.path,
      aspectRatioPresets: [CropAspectRatioPreset.square, CropAspectRatioPreset.original],
      uiSettings: [
        AndroidUiSettings(toolbarTitle: 'Crop Image', toolbarColor: Colors.deepOrange, toolbarWidgetColor: Colors.white),
        IOSUiSettings(title: 'Crop Image'),
      ],
    );
    if (croppedFile == null) return;

    final cropped = File(croppedFile.path);
    if (!mounted) return;
    setState(() {
      _image = cropped;
    });

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => ProcessingScreen(imageFile: _image!)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Capture Image')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Use camera or gallery to pick a food image.'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text('Capture Image'),
              onPressed: () => _pickImage(ImageSource.camera),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.photo_library),
              label: const Text('Choose from Gallery'),
              onPressed: () => _pickImage(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }
}
