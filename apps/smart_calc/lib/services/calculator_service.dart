import 'dart:math' as math;
import 'package:math_expressions/math_expressions.dart';

class CalculatorService {
  String calculate(String expression) {
    try {
      if (expression.isEmpty) return '0';

      String cleanExpression = expression
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('π', math.pi.toString())
          .replaceAll('e', math.e.toString());

      if (cleanExpression.contains('√')) {
        cleanExpression = _handleSquareRoot(cleanExpression);
      }

      Parser p = Parser();
      Expression exp = p.parse(cleanExpression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      if (eval.isNaN || eval.isInfinite) {
        return 'Error';
      }

      if (eval == eval.toInt()) {
        return eval.toInt().toString();
      }

      return eval.toStringAsFixed(8).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
    } catch (e) {
      return 'Error';
    }
  }

  String _handleSquareRoot(String expression) {
    while (expression.contains('√')) {
      int index = expression.indexOf('√');
      String remaining = expression.substring(index + 1);

      String number = '';
      int i = 0;
      bool inParentheses = false;
      int parenthesesCount = 0;

      if (remaining.startsWith('(')) {
        inParentheses = true;
        parenthesesCount = 1;
        i = 1;
        number = '(';

        while (i < remaining.length && parenthesesCount > 0) {
          if (remaining[i] == '(') parenthesesCount++;
          if (remaining[i] == ')') parenthesesCount--;
          number += remaining[i];
          i++;
        }
      } else {
        while (i < remaining.length && (remaining[i].contains(RegExp(r'[0-9.]')))) {
          number += remaining[i];
          i++;
        }
      }

      if (number.isEmpty) {
        return expression.replaceFirst('√', 'sqrt(0)');
      }

      String sqrtValue = 'sqrt($number)';
      expression = expression.substring(0, index) + sqrtValue + remaining.substring(i);
    }
    return expression;
  }

  double calculateScientific(String function, double value, {double? secondValue}) {
    try {
      switch (function) {
        case 'sin':
          return math.sin(value);
        case 'cos':
          return math.cos(value);
        case 'tan':
          return math.tan(value);
        case 'asin':
          return math.asin(value);
        case 'acos':
          return math.acos(value);
        case 'atan':
          return math.atan(value);
        case 'log':
          return math.log(value) / math.ln10;
        case 'ln':
          return math.log(value);
        case 'sqrt':
          return math.sqrt(value);
        case 'pow':
          return math.pow(value, secondValue ?? 2).toDouble();
        case 'exp':
          return math.exp(value);
        default:
          return 0;
      }
    } catch (e) {
      return double.nan;
    }
  }

  double degreesToRadians(double degrees) {
    return degrees * math.pi / 180;
  }

  double radiansToDegrees(double radians) {
    return radians * 180 / math.pi;
  }
}
