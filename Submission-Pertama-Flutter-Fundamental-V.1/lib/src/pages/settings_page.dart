// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';
import '../../src/services/background_service.dart';
import '../services/notification_service.dart';
import '../providers/settings_provider.dart';

class SettingsPage extends StatefulWidget {
  static const routeName = '/settings';

  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    // Use context.watch/read for clearer intent and local variables for values.
    final isDark = context.watch<SettingsProvider>().isDark;
    final dailyReminderActive = context
        .watch<SettingsProvider>()
        .dailyReminderActive;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            value: isDark,
            title: const Text('Dark Theme'),
            onChanged: (v) async {
              final provider = context.read<SettingsProvider>();
              try {
                await provider.setDarkTheme(v);
                if (!mounted) return;
                final messenger = ScaffoldMessenger.of(context);
                messenger.showSnackBar(
                  SnackBar(
                    content: Text('Theme set to ${v ? 'Dark' : 'Light'}'),
                  ),
                );
              } catch (e) {
                if (!mounted) return;
                // Log the error for debugging and show a friendly message to the user.
                // ignore: avoid_print
                print('Failed to set theme: $e');
                final messenger = ScaffoldMessenger.of(context);
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('Could not change theme. Please try again.'),
                  ),
                );
              }
            },
          ),
          const Divider(),
          SwitchListTile(
            value: dailyReminderActive,
            title: const Text('Daily Reminder (11:00 AM)'),
            subtitle: const Text(
              'Receive a daily recommended restaurant at 11:00 AM',
            ),
            onChanged: (v) async {
              final provider = context.read<SettingsProvider>();
              try {
                await provider.setDailyReminderActive(v);
                if (!mounted) return;
                final messenger = ScaffoldMessenger.of(context);
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      'Daily reminder ${v ? 'enabled' : 'disabled'}',
                    ),
                  ),
                );
              } catch (e) {
                if (!mounted) return;
                // Log and show friendly error
                // ignore: avoid_print
                print('Failed to update reminder: $e');
                final messenger = ScaffoldMessenger.of(context);
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('Could not update reminder settings.'),
                  ),
                );
              }
            },
          ),
          // Test notification button (visible in all builds) so reviewers can
          // quickly verify notification behavior on devices (Android 13+).
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: ElevatedButton.icon(
              key: const Key('send_test_notification'),
              icon: const Icon(Icons.notifications),
              label: const Text('Send Test Notification'),
              onPressed: () async {
                try {
                  // Ensure notification permission; request if denied.
                  try {
                    if (await Permission.notification.isDenied) {
                      final status = await Permission.notification.request();
                      if (!status.isGranted) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Notification permission not granted',
                            ),
                          ),
                        );
                        return;
                      }
                    }
                  } catch (_) {
                    // If permission_handler isn't available on a platform,
                    // proceed to attempt to send the notification anyway.
                  }

                  await NotificationService.showTestNotification();
                  if (!mounted) return;
                  final messenger = ScaffoldMessenger.of(context);
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Test notification sent')),
                  );
                } catch (e) {
                  if (!mounted) return;
                  // ignore: avoid_print
                  print('Failed to send test notification: $e');
                  final messenger = ScaffoldMessenger.of(context);
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Failed to send test notification'),
                    ),
                  );
                }
              },
            ),
          ),
          // Debug-only: trigger the WorkManager callback immediately. This
          // helps device testing without waiting for scheduled alarms. Hidden
          // in release builds.
          if (kDebugMode)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.bug_report),
                label: const Text('Trigger Background Job (debug)'),
                onPressed: () async {
                  try {
                    // Run the background logic immediately on the main isolate
                    // for testing purposes without invoking the Workmanager entry
                    // point directly.
                    BackgroundService.runNow();
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Background job triggered (debug)'),
                      ),
                    );
                  } catch (e) {
                    if (!mounted) return;
                    // ignore: avoid_print
                    print('Failed to trigger background job: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to trigger background job'),
                      ),
                    );
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}
