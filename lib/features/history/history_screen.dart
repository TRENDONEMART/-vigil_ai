import 'package:flutter/material.dart';

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
      case "critical":
        return Colors.red.shade900;
      case "high":
        return Colors.red;
      case "medium":
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan History"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: history.isEmpty ? null : clearAll,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: loadHistory,
        child: history.isEmpty
            ? const Center(
                child: Text("No Scan History", style: TextStyle(fontSize: 18)),
              )
            : ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final item = history[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: riskColor(item.riskLevel),
                        child: Text(
                          item.riskScore.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(item.type),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.fraudType),
                          Text(
                            item.input,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            item.dateTime.toString(),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => deleteItem(index),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
