import 'package:flutter/material.dart';

class ResultsPage extends StatefulWidget {
  final String? email;
  final String? timestamp;

  const ResultsPage({super.key, this.email, this.timestamp});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  String email = '';
  String timestamp = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (widget.email != null && email.isEmpty) email = widget.email!;
    if (widget.timestamp != null && timestamp.isEmpty) timestamp = widget.timestamp!;
    if (args is Map) {
      if (args['email'] != null) email = args['email'] as String;
      if (args['timestamp'] != null) timestamp = args['timestamp'] as String;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: screenWidth < 600 ? screenWidth : 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, ${email.isNotEmpty ? email : 'Guest'}!',
                  style: TextStyle(fontSize: screenWidth < 600 ? 20 : 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (timestamp.isNotEmpty) Text('Last login: $timestamp', style: TextStyle(fontSize: screenWidth < 600 ? 12 : 14, color: Colors.grey[700])),
                const SizedBox(height: 12),
                Text(
                  'This is a sample results/content page. You can display personalized content here based on user input.',
                  style: TextStyle(fontSize: screenWidth < 600 ? 14 : 16),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/gallery'),
                  child: const Text('Open Gallery'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/')),
                  child: const Text('Back to Home'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
