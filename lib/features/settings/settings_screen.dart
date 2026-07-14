import 'package:flutter/material.dart';

import '../../shared/widgets/premium_widgets.dart';
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
    if (shouldClear != true) return;
    await HistoryService.clearHistory();
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Scan history cleared.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 30),
        children: [
          const PremiumPageIntro(
            eyebrow: 'Control center',
            title: 'Your privacy, your rules',
            subtitle:
                'Vigil AI is designed to keep safety checks on your device.',
            icon: Icons.tune,
          ),
          const SizedBox(height: 24),
          Card(
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.shield_outlined),
                  title: Text(
                    'Protection',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    'Offline rules help keep your content private.',
                  ),
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.offline_bolt_outlined),
                  title: const Text('Offline analysis'),
                  subtitle: const Text('Use the built-in fraud engine.'),
                  value: _offlineAnalysis,
                  onChanged: (value) =>
                      setState(() => _offlineAnalysis = value),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Card(
            child: ListTile(
              leading: const Icon(Icons.delete_sweep_outlined),
              title: const Text(
                'Clear scan history',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: const Text('Remove all saved safety checks.'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _clearHistory,
            ),
          ),
          const SizedBox(height: 14),
          const Card(
            child: ListTile(
              leading: Icon(Icons.info_outline),
              title: Text(
                'About Vigil AI',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text('Offline fraud detection • Version 1.0.0'),
            ),
          ),
        ],
      ),
    );
  }
}
