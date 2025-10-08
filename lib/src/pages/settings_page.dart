import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class SettingsPage extends StatelessWidget {
  static const routeName = '/settings';

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
  final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            value: settings.isDark,
            title: const Text('Dark Theme'),
            onChanged: (v) async {
              final messenger = ScaffoldMessenger.of(context);
              await settings.setDarkTheme(v);
              messenger.showSnackBar(
                SnackBar(content: Text('Theme set to ${v ? 'Dark' : 'Light'}')),
              );
            },
          ),
          const Divider(),
          SwitchListTile(
            value: settings.dailyReminderActive,
            title: const Text('Daily Reminder (11:00 AM)'),
            subtitle: const Text('Receive a daily recommended restaurant at 11:00 AM'),
            onChanged: (v) async {
              final messenger = ScaffoldMessenger.of(context);
              await settings.setDailyReminderActive(v);
              messenger.showSnackBar(
                SnackBar(content: Text('Daily reminder ${v ? 'enabled' : 'disabled'}')),
              );
            },
          ),
        ],
      ),
    );
  }
}
