import 'package:flutter/material.dart';
import '../widgets/calculator_button.dart';
import '../widgets/calculator_display.dart';
import '../services/calculator_service.dart';
import '../services/history_service.dart';
import '../models/history_entry.dart';

class ScientificCalculatorScreen extends StatefulWidget {
  const ScientificCalculatorScreen({super.key});

  @override
  State<ScientificCalculatorScreen> createState() => _ScientificCalculatorScreenState();
}

class _ScientificCalculatorScreenState extends State<ScientificCalculatorScreen> {
  String _expression = '';
  String _result = '';
  bool _isDegreeMode = true;
  final CalculatorService _calculatorService = CalculatorService();
  final HistoryService _historyService = HistoryService();

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C' || value == 'AC') {
        _expression = '';
        _result = '';
      } else if (value == '⌫') {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
      } else if (value == '=') {
        _calculateResult();
      } else if (['sin', 'cos', 'tan', 'log', 'ln'].contains(value)) {
        _expression += '$value(';
      } else if (value == 'π') {
        _expression += 'π';
      } else if (value == 'e') {
        _expression += 'e';
      } else if (value == 'x²') {
        _expression += '^2';
      } else if (value == 'x³') {
        _expression += '^3';
      } else if (value == '^') {
        _expression += '^';
      } else if (value == '√') {
        _expression += '√';
      } else {
        if (_result.isNotEmpty && RegExp(r'^[0-9.]$').hasMatch(value)) {
          _expression = value;
          _result = '';
        } else {
          _expression += value;
        }
      }
    });
  }

  void _calculateResult() {
    if (_expression.isEmpty) return;

    String result = _calculatorService.calculate(_expression);
    setState(() {
      _result = result;
    });

    if (result != 'Error') {
      _historyService.addEntry(
        HistoryEntry(
          expression: _expression,
          result: result,
          timestamp: DateTime.now(),
          calculatorType: 'Scientific',
        ),
      );
    }
  }

  void _toggleAngleMode() {
    setState(() {
      _isDegreeMode = !_isDegreeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scientific Calculator'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: TextButton(
                onPressed: _toggleAngleMode,
                child: Text(
                  _isDegreeMode ? 'DEG' : 'RAD',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CalculatorDisplay(
                expression: _expression,
                result: _result,
                showResult: _result.isNotEmpty,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: CalculatorButton(text: 'sin', onPressed: () => _onButtonPressed('sin'), fontSize: 16)),
                        Expanded(child: CalculatorButton(text: 'cos', onPressed: () => _onButtonPressed('cos'), fontSize: 16)),
                        Expanded(child: CalculatorButton(text: 'tan', onPressed: () => _onButtonPressed('tan'), fontSize: 16)),
                        Expanded(child: CalculatorButton(text: 'π', onPressed: () => _onButtonPressed('π'))),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: CalculatorButton(text: 'log', onPressed: () => _onButtonPressed('log'), fontSize: 16)),
                        Expanded(child: CalculatorButton(text: 'ln', onPressed: () => _onButtonPressed('ln'), fontSize: 16)),
                        Expanded(child: CalculatorButton(text: 'e', onPressed: () => _onButtonPressed('e'))),
                        Expanded(child: CalculatorButton(text: '^', onPressed: () => _onButtonPressed('^'))),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: CalculatorButton(text: 'C', onPressed: () => _onButtonPressed('C'))),
                        Expanded(child: CalculatorButton(text: '⌫', onPressed: () => _onButtonPressed('⌫'))),
                        Expanded(child: CalculatorButton(text: '%', onPressed: () => _onButtonPressed('%'))),
                        Expanded(child: CalculatorButton(text: '÷', onPressed: () => _onButtonPressed('÷'))),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: CalculatorButton(text: '7', onPressed: () => _onButtonPressed('7'))),
                        Expanded(child: CalculatorButton(text: '8', onPressed: () => _onButtonPressed('8'))),
                        Expanded(child: CalculatorButton(text: '9', onPressed: () => _onButtonPressed('9'))),
                        Expanded(child: CalculatorButton(text: '×', onPressed: () => _onButtonPressed('×'))),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: CalculatorButton(text: '4', onPressed: () => _onButtonPressed('4'))),
                        Expanded(child: CalculatorButton(text: '5', onPressed: () => _onButtonPressed('5'))),
                        Expanded(child: CalculatorButton(text: '6', onPressed: () => _onButtonPressed('6'))),
                        Expanded(child: CalculatorButton(text: '-', onPressed: () => _onButtonPressed('-'))),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: CalculatorButton(text: '1', onPressed: () => _onButtonPressed('1'))),
                        Expanded(child: CalculatorButton(text: '2', onPressed: () => _onButtonPressed('2'))),
                        Expanded(child: CalculatorButton(text: '3', onPressed: () => _onButtonPressed('3'))),
                        Expanded(child: CalculatorButton(text: '+', onPressed: () => _onButtonPressed('+'))),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: CalculatorButton(text: '(', onPressed: () => _onButtonPressed('('))),
                        Expanded(child: CalculatorButton(text: '0', onPressed: () => _onButtonPressed('0'))),
                        Expanded(child: CalculatorButton(text: ')', onPressed: () => _onButtonPressed(')'))),
                        Expanded(child: CalculatorButton(text: '=', onPressed: () => _onButtonPressed('='))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
