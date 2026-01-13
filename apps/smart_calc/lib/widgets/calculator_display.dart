import 'package:flutter/material.dart';

class CalculatorDisplay extends StatelessWidget {
  final String expression;
  final String result;
  final bool showResult;

  const CalculatorDisplay({
    super.key,
    required this.expression,
    required this.result,
    this.showResult = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    double expressionFontSize = _calculateFontSize(expression, screenWidth, 32);
    double resultFontSize = _calculateFontSize(result, screenWidth, 48);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Text(
                expression.isEmpty ? '0' : expression,
                style: TextStyle(
                  fontSize: expressionFontSize,
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.visible,
              ),
            ),
          ),
          if (showResult && result.isNotEmpty) ...[
            const SizedBox(height: 4),
            const Divider(height: 1),
            const SizedBox(height: 4),
            Flexible(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: Text(
                  result,
                  style: TextStyle(
                    fontSize: resultFontSize,
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  double _calculateFontSize(String text, double screenWidth, double baseFontSize) {
    int length = text.length;
    if (length <= 10) return baseFontSize;
    if (length <= 15) return baseFontSize * 0.8;
    if (length <= 20) return baseFontSize * 0.6;
    return baseFontSize * 0.5;
  }
}
