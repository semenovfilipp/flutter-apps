import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/history_entry.dart';
import '../services/history_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final HistoryService _historyService = HistoryService();
  List<HistoryEntry> _history = [];
  String _filterType = 'All';

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    List<HistoryEntry> history;
    if (_filterType == 'All') {
      history = await _historyService.getHistory();
    } else {
      history = await _historyService.getHistoryByType(_filterType);
    }
    setState(() {
      _history = history;
    });
  }

  Future<void> _clearHistory() async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text('Are you sure you want to clear all history?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _historyService.clearHistory();
      _loadHistory();
    }
  }

  Future<void> _deleteEntry(int index) async {
    await _historyService.deleteEntry(index);
    _loadHistory();
  }

  void _changeFilter(String? newFilter) {
    if (newFilter != null) {
      setState(() {
        _filterType = newFilter;
      });
      _loadHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filters = ['All', 'Basic', 'Scientific', 'Currency', 'Unit'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: _history.isEmpty ? null : _clearHistory,
            tooltip: 'Clear History',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonFormField<String>(
                value: _filterType,
                decoration: const InputDecoration(
                  labelText: 'Filter by type',
                  border: InputBorder.none,
                ),
                items: filters.map((filter) {
                  return DropdownMenuItem(
                    value: filter,
                    child: Text(filter),
                  );
                }).toList(),
                onChanged: _changeFilter,
              ),
            ),
          ),
          Expanded(
            child: _history.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 64,
                          color: theme.colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No history yet',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _history.length,
                    itemBuilder: (context, index) {
                      final entry = _history[index];
                      final formattedDate = DateFormat('MMM dd, yyyy - HH:mm').format(entry.timestamp);

                      return Dismissible(
                        key: Key('${entry.timestamp.millisecondsSinceEpoch}'),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          _deleteEntry(index);
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: theme.colorScheme.primaryContainer,
                              child: Icon(
                                _getIconForType(entry.calculatorType),
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                            title: Text(
                              entry.expression,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  '= ${entry.result}',
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formattedDate,
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                            trailing: Chip(
                              label: Text(
                                entry.calculatorType,
                                style: const TextStyle(fontSize: 10),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                            ),
                            isThreeLine: true,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'Basic':
        return Icons.calculate;
      case 'Scientific':
        return Icons.science;
      case 'Currency':
        return Icons.currency_exchange;
      case 'Unit':
        return Icons.straighten;
      default:
        return Icons.history;
    }
  }
}
