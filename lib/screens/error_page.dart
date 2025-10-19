import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Read optional message from route arguments
    String message = 'An error occurred.';
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String) message = args;

    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenWidth < 600 ? screenWidth : 600,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Semantics(
                  label: 'Error',
                  child: Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[700],
                  ),
                ),
                const SizedBox(height: 12),
                Semantics(
                  liveRegion: true,
                  label: 'Error message',
                  child: Text(
                    message,
                    style: TextStyle(fontSize: screenWidth < 600 ? 16 : 20),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                Semantics(
                  button: true,
                  label: 'Back',
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Back'),
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
