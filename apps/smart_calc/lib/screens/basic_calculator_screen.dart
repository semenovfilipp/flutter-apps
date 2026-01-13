import 'package:flutter/material.dart';
import '../widgets/calculator_button.dart';
import '../widgets/calculator_display.dart';
import '../services/calculator_service.dart';
import '../services/history_service.dart';
import '../models/history_entry.dart';

class BasicCalculatorScreen extends StatefulWidget {
  const BasicCalculatorScreen({super.key});

  @override
  State<BasicCalculatorScreen> createState() => _BasicCalculatorScreenState();
}

class _BasicCalculatorScreenState extends State<BasicCalculatorScreen> {
  String _expression = '';
  String _result = '';
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
          calculatorType: 'Basic',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Calculator'),
        centerTitle: true,
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
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
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
                        Expanded(child: CalculatorButton(text: '√', onPressed: () => _onButtonPressed('√'))),
                        Expanded(child: CalculatorButton(text: '0', onPressed: () => _onButtonPressed('0'))),
                        Expanded(child: CalculatorButton(text: '.', onPressed: () => _onButtonPressed('.'))),
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
