import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submission Pertama'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Text(
                    'Belajar Membuat Aplikasi Flutter untuk Pemula',
                    style: TextStyle(
                      fontSize: screenWidth < 600 ? 20 : 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Proyek sederhana untuk mempelajari widget statis dan dinamis, navigasi, dan layout responsif.',
                    style: TextStyle(fontSize: screenWidth < 600 ? 14 : 16, color: Colors.grey[800]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Semantics(
                    label: 'Welcome image',
                    child: Image.asset(
                      'assets/welcome.png',
                      width: screenWidth < 600 ? 140 : 220,
                      height: screenWidth < 600 ? 140 : 220,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: screenWidth < 600 ? 140 : 220,
                        height: screenWidth < 600 ? 140 : 220,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: screenWidth < 600 ? double.infinity : 300,
                    height: 48,
                    child: Semantics(
                      button: true,
                      label: 'Sign In',
                      child: ElevatedButton(
                        key: const Key('home_sign_in'),
                        onPressed: () => Navigator.pushNamed(context, '/login'),
                        child: const Text('Sign In'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Semantics(
                    button: true,
                    label: 'Open Gallery',
                    child: TextButton(
                      key: const Key('home_open_gallery'),
                      onPressed: () => Navigator.pushNamed(context, '/gallery'),
                      child: const Text('Open Gallery'),
                    ),
                  ),
                ],
              ),
            );
            },
          ),
        ),
      ),
    );
  }
}
