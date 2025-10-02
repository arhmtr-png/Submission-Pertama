import 'package:flutter/material.dart';
import 'details_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome to Submission Pertama!',
                    style: TextStyle(
                      fontSize: screenWidth < 600 ? 24 : 32,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Image.asset(
                    'assets/welcome.png',
                    width: screenWidth < 600 ? 150 : 250,
                    height: screenWidth < 600 ? 150 : 250,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DetailsPage()),
                      );
                    },
                    child: const Text('Go to Details Page'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
