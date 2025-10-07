import 'package:flutter/material.dart';

class ResultsPage extends StatelessWidget {
  final String? email;
  final String? timestamp;

  const ResultsPage({super.key, this.email, this.timestamp});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Prefer route arguments over constructor values when provided.
    String finalEmail = email ?? '';
    String finalTimestamp = timestamp ?? '';
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      if (args['email'] != null) finalEmail = args['email'] as String;
      if (args['timestamp'] != null) {
        finalTimestamp = args['timestamp'] as String;
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Results')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenWidth < 600 ? screenWidth : 700,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  header: true,
                  label: 'Welcome message',
                  child: Text(
                    'Welcome, ${finalEmail.isNotEmpty ? finalEmail : 'Guest'}!',
                    style: TextStyle(
                      fontSize: screenWidth < 600 ? 20 : 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                if (finalTimestamp.isNotEmpty)
                  Text(
                    'Last login: $finalTimestamp',
                    style: TextStyle(
                      fontSize: screenWidth < 600 ? 12 : 14,
                      color: Colors.grey[700],
                    ),
                  ),
                const SizedBox(height: 12),
                Text(
                  'This is a sample results/content page. You can display personalized content here based on user input.',
                  style: TextStyle(fontSize: screenWidth < 600 ? 14 : 16),
                ),
                const SizedBox(height: 20),
                Semantics(
                  button: true,
                  label: 'Open Gallery',
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/gallery'),
                    child: const Text('Open Gallery'),
                  ),
                ),
                const SizedBox(height: 12),
                Semantics(
                  button: true,
                  label: 'Back to Home',
                  child: TextButton(
                    onPressed: () =>
                        Navigator.popUntil(context, ModalRoute.withName('/')),
                    child: const Text('Back to Home'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
