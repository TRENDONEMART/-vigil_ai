import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'history_item.dart';

class HistoryService {
  static const String _key = 'scan_history';

  static Future<void> addHistory(HistoryItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_key) ?? [];

    if (item.type == 'QR') {
      final duplicateIndex = history.indexWhere((entry) {
        final existingItem = HistoryItem.fromJson(jsonDecode(entry));

        return existingItem.type == 'QR' &&
            existingItem.input.trim() == item.input.trim();
      });

      if (duplicateIndex >= 0) {
        history.removeAt(duplicateIndex);
      }
    }

    history.insert(0, jsonEncode(item.toJson()));

    await prefs.setStringList(_key, history);
  }

  static Future<List<HistoryItem>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_key) ?? [];

    return history
        .map((entry) => HistoryItem.fromJson(jsonDecode(entry)))
        .toList();
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_key);
  }

  static Future<void> deleteHistory(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_key) ?? [];

    if (index >= 0 && index < history.length) {
      history.removeAt(index);
      await prefs.setStringList(_key, history);
    }
  }
}
