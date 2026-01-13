import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/history_entry.dart';

class HistoryService {
  static const String _historyKey = 'calculator_history';
  static const int _maxHistorySize = 100;

  Future<void> addEntry(HistoryEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    List<HistoryEntry> history = await getHistory();

    history.insert(0, entry);

    if (history.length > _maxHistorySize) {
      history = history.sublist(0, _maxHistorySize);
    }

    List<String> jsonList = history.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList(_historyKey, jsonList);
  }

  Future<List<HistoryEntry>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList(_historyKey);

    if (jsonList == null) return [];

    return jsonList
        .map((jsonStr) => HistoryEntry.fromJson(json.decode(jsonStr)))
        .toList();
  }

  Future<List<HistoryEntry>> getHistoryByType(String type) async {
    List<HistoryEntry> allHistory = await getHistory();
    return allHistory.where((entry) => entry.calculatorType == type).toList();
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }

  Future<void> deleteEntry(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<HistoryEntry> history = await getHistory();

    if (index >= 0 && index < history.length) {
      history.removeAt(index);
      List<String> jsonList = history.map((e) => json.encode(e.toJson())).toList();
      await prefs.setStringList(_historyKey, jsonList);
    }
  }
}
