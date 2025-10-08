import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class SettingsPage extends StatelessWidget {
  static const routeName = '/settings';

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Use context.watch/read for clearer intent and local variables for values.
    final isDark = context.watch<SettingsProvider>().isDark;
    final dailyReminderActive = context.watch<SettingsProvider>().dailyReminderActive;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            value: isDark,
            title: const Text('Dark Theme'),
            onChanged: (v) async {
              final messenger = ScaffoldMessenger.of(context);
              try {
                await context.read<SettingsProvider>().setDarkTheme(v);
                messenger.showSnackBar(
                  SnackBar(content: Text('Theme set to ${v ? 'Dark' : 'Light'}')),
                );
              } catch (e) {
                messenger.showSnackBar(
                  SnackBar(content: Text('Failed to set theme: $e')),
                );
              }
            },
          ),
          const Divider(),
          SwitchListTile(
            value: dailyReminderActive,
            title: const Text('Daily Reminder (11:00 AM)'),
            subtitle: const Text('Receive a daily recommended restaurant at 11:00 AM'),
            onChanged: (v) async {
              final messenger = ScaffoldMessenger.of(context);
              try {
                await context.read<SettingsProvider>().setDailyReminderActive(v);
                messenger.showSnackBar(
                  SnackBar(content: Text('Daily reminder ${v ? 'enabled' : 'disabled'}')),
                );
              } catch (e) {
                messenger.showSnackBar(
                  SnackBar(content: Text('Failed to update reminder: $e')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
