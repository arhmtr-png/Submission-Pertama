import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import '../src/services/notification_service.dart';

class DevScreen extends StatelessWidget {
  const DevScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return const SizedBox.shrink();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dev Tools'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              key: const Key('dev_send_notification'),
              onPressed: () async {
                await NotificationService.showImmediateTestNotification();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Test notification sent')),
                );
              },
              child: const Text('Send Test Notification'),
            ),
            const SizedBox(height: 12),
            Text(
              'Developer tools are only available in debug builds.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
