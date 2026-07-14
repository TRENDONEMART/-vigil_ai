import 'package:flutter/material.dart';

import '../../shared/widgets/premium_widgets.dart';
import 'history_item.dart';
import 'history_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<HistoryItem> history = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    final loadedHistory = await HistoryService.getHistory();
    if (!mounted) return;
    setState(() => history = loadedHistory);
  }

  Future<void> clearAll() async {
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
    await loadHistory();
  }

  Future<void> deleteItem(int index) async {
    await HistoryService.deleteHistory(index);
    await loadHistory();
  }

  Color riskColor(String level) {
    switch (level.toLowerCase()) {
      case 'critical':
        return const Color(0xFFFF5574);
      case 'high':
        return const Color(0xFFFF8066);
      case 'medium':
        return const Color(0xFFFFC857);
      default:
        return const Color(0xFF4DE1E8);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            onPressed: history.isEmpty ? null : clearAll,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: loadHistory,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
          children: [
            const PremiumPageIntro(
              eyebrow: 'Your activity',
              title: 'Scan history',
              subtitle: 'A private timeline of your recent safety checks.',
              icon: Icons.history,
            ),
            const SizedBox(height: 24),
            if (history.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 48,
                    horizontal: 24,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.auto_awesome_motion_outlined,
                        size: 42,
                        color: Colors.white.withValues(alpha: 0.38),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Your history is clear',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Completed scans will appear here.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white54),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...history.asMap().entries.map((entry) {
                final item = entry.value;
                final color = riskColor(item.riskLevel);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: Container(
                        height: 46,
                        width: 46,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          item.riskScore.toString(),
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      title: Text(
                        item.type,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '${item.fraudType}\n${item.input}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => deleteItem(entry.key),
                      ),
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
