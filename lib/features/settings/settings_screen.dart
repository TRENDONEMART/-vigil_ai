import 'package:flutter/material.dart';

import '../history/history_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _offlineAnalysis = true;

  Future<void> _clearHistory() async {
    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear scan history?'),
        content: const Text('This will permanently remove all saved scans.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (shouldClear == true) {
      await HistoryService.clearHistory();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Scan history cleared.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const ListTile(
            leading: Icon(Icons.shield_outlined),
            title: Text('Protection'),
            subtitle: Text('Vigil AI analyzes your scans on-device.'),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.offline_bolt_outlined),
            title: const Text('Offline analysis'),
            subtitle: const Text('Use the built-in offline fraud engine.'),
            value: _offlineAnalysis,
            onChanged: (value) => setState(() => _offlineAnalysis = value),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete_sweep_outlined),
            title: const Text('Clear scan history'),
            subtitle: const Text(
              'Remove all saved message, link, QR, and UPI scans.',
            ),
            onTap: _clearHistory,
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About Vigil AI'),
            subtitle: Text('Offline fraud detection • Version 1.0.0'),
          ),
        ],
      ),
    );
  }
}
