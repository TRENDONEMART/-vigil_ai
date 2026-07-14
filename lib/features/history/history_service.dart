import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'history_item.dart';

class HistoryService {
  static const String _key = "scan_history";

  static Future<void> addHistory(HistoryItem item) async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> history =
        prefs.getStringList(_key) ?? [];

    history.insert(0, jsonEncode(item.toJson()));

    await prefs.setStringList(_key, history);
  }

  static Future<List<HistoryItem>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> history =
        prefs.getStringList(_key) ?? [];

    return history
        .map(
          (e) => HistoryItem.fromJson(
        jsonDecode(e),
      ),
    )
        .toList();
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_key);
  }

  static Future<void> deleteHistory(int index) async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> history =
        prefs.getStringList(_key) ?? [];

    if (index >= 0 && index < history.length) {
      history.removeAt(index);
      await prefs.setStringList(_key, history);
    }
  }
}