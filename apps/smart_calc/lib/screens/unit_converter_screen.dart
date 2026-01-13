import 'package:flutter/material.dart';
import '../services/unit_converter.dart';
import '../services/history_service.dart';
import '../models/history_entry.dart';

class UnitConverterScreen extends StatefulWidget {
  const UnitConverterScreen({super.key});

  @override
  State<UnitConverterScreen> createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends State<UnitConverterScreen> {
  final UnitConverter _converter = UnitConverter();
  final HistoryService _historyService = HistoryService();
  final TextEditingController _valueController = TextEditingController();

  String _category = 'Length';
  String _fromUnit = 'Meters';
  String _toUnit = 'Kilometers';
  double _result = 0.0;

  @override
  void initState() {
    super.initState();
    _valueController.addListener(_convert);
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  void _convert() {
    if (_valueController.text.isEmpty) {
      setState(() {
        _result = 0.0;
      });
      return;
    }

    double value = double.tryParse(_valueController.text) ?? 0.0;
    setState(() {
      _result = _converter.convert(value, _category, _fromUnit, _toUnit);
    });

    if (value != 0) {
      _historyService.addEntry(
        HistoryEntry(
          expression: '$value $_fromUnit to $_toUnit',
          result: '$_result $_toUnit',
          timestamp: DateTime.now(),
          calculatorType: 'Unit',
        ),
      );
    }
  }

  void _swapUnits() {
    setState(() {
      String temp = _fromUnit;
      _fromUnit = _toUnit;
      _toUnit = temp;
      _convert();
    });
  }

  void _onCategoryChanged(String? newCategory) {
    if (newCategory != null) {
      setState(() {
        _category = newCategory;
        List<String> units = _converter.getUnits(_category);
        _fromUnit = units.first;
        _toUnit = units.length > 1 ? units[1] : units.first;
        _convert();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = _converter.categories;
    final units = _converter.getUnits(_category);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Unit Converter'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: InputBorder.none,
                ),
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(
                      category,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  );
                }).toList(),
                onChanged: _onCategoryChanged,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    'From',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _valueController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: '0.00',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _fromUnit,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                    ),
                    items: units.map((unit) {
                      return DropdownMenuItem(
                        value: unit,
                        child: Text(
                          unit,
                          style: const TextStyle(fontSize: 18),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _fromUnit = value!;
                        _convert();
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: FloatingActionButton(
                onPressed: _swapUnits,
                child: const Icon(Icons.swap_vert),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    'To',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onTertiaryContainer,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _result.toString(),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _toUnit,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                    ),
                    items: units.map((unit) {
                      return DropdownMenuItem(
                        value: unit,
                        child: Text(
                          unit,
                          style: const TextStyle(fontSize: 18),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _toUnit = value!;
                        _convert();
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
