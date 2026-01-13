import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/formula.dart';
import '../services/calculator_service.dart';

class CalculatorScreen extends StatefulWidget {
  final Formula formula;

  const CalculatorScreen({Key? key, required this.formula}) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final Map<String, TextEditingController> _controllers = {};
  String? _result;
  String? _error;
  String? _solveFor; // Variable to solve for

  @override
  void initState() {
    super.initState();
    // Create controllers for each variable
    widget.formula.variables.forEach((key, value) {
      _controllers[key] = TextEditingController();
    });
    // Default to solving for the first variable (usually the result)
    _solveFor = widget.formula.variables.keys.first;
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  void _calculate() {
    setState(() {
      _error = null;
      _result = null;
    });

    if (_solveFor == null) {
      setState(() {
        _error = 'Выберите переменную для вычисления';
      });
      return;
    }

    // Validate all fields except the one we're solving for are filled
    for (var entry in _controllers.entries) {
      if (entry.key != _solveFor && entry.value.text.trim().isEmpty) {
        setState(() {
          _error = 'Заполните все известные поля';
        });
        return;
      }
    }

    // Parse values (excluding the variable we're solving for)
    final Map<String, double> values = {};
    try {
      _controllers.forEach((key, controller) {
        if (key != _solveFor && controller.text.trim().isNotEmpty) {
          values[key] = double.parse(controller.text.trim());
        }
      });
    } catch (e) {
      setState(() {
        _error = 'Некорректные числовые значения';
      });
      return;
    }

    // Calculate
    final result = CalculatorService.solveFor(
      widget.formula.id,
      _solveFor!,
      values,
    );

    setState(() {
      if (result != null && !result.startsWith('Ошибка')) {
        _result = '$_solveFor = $result';
        _controllers[_solveFor!]!.text = result;
      } else {
        _error = result ?? 'Ошибка вычисления';
      }
    });
  }

  void _clearAll() {
    setState(() {
      _controllers.forEach((key, controller) {
        controller.clear();
      });
      _result = null;
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.formula.name),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: _clearAll,
            tooltip: 'Очистить',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Formula display
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Формула:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.formula.formulaText,
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.formula.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Select what to solve for
            const Text(
              'Найти:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _solveFor,
                  items: widget.formula.variables.entries.map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text('${entry.key} - ${entry.value}'),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _solveFor = newValue;
                      _result = null;
                      _error = null;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Variables
            const Text(
              'Известные значения:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            ...widget.formula.variables.entries.map((entry) {
              final isSolvingFor = entry.key == _solveFor;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${entry.key} - ${entry.value}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (isSolvingFor) ...[
                          const SizedBox(width: 8),
                          const Chip(
                            label: Text(
                              'Вычисляется',
                              style: TextStyle(fontSize: 11),
                            ),
                            backgroundColor: Colors.green,
                            labelStyle: TextStyle(color: Colors.white),
                            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _controllers[entry.key],
                      enabled: !isSolvingFor,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^-?\d*\.?\d*'),
                        ),
                      ],
                      decoration: InputDecoration(
                        hintText: isSolvingFor
                            ? 'Будет вычислено'
                            : 'Введите значение ${entry.key}',
                        border: const OutlineInputBorder(),
                        prefixIcon: Icon(
                          isSolvingFor ? Icons.calculate : Icons.edit,
                        ),
                        filled: isSolvingFor,
                        fillColor: isSolvingFor ? Colors.grey.shade100 : null,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),

            const SizedBox(height: 24),

            // Calculate button
            ElevatedButton(
              onPressed: _calculate,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Вычислить'),
            ),

            const SizedBox(height: 24),

            // Result or error
            if (_result != null)
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Результат:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _result!,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            if (_error != null)
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.red),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _error!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Example
            if (widget.formula.example != null) ...[
              const SizedBox(height: 24),
              Card(
                color: Colors.amber.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.lightbulb, color: Colors.orange),
                          SizedBox(width: 8),
                          Text(
                            'Пример:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.formula.example!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
