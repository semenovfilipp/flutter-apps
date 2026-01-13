import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final bool isWide;

  const CalculatorButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.isWide = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color defaultBgColor;
    Color defaultTextColor;

    if (text == '=' || text == 'Calculate') {
      defaultBgColor = theme.colorScheme.primary;
      defaultTextColor = theme.colorScheme.onPrimary;
    } else if (RegExp(r'[+\-×÷√%^]').hasMatch(text) ||
        ['C', 'AC', '⌫', 'DEL'].contains(text)) {
      defaultBgColor = isDark
          ? theme.colorScheme.secondary.withOpacity(0.3)
          : theme.colorScheme.secondary.withOpacity(0.2);
      defaultTextColor = theme.colorScheme.onSurface;
    } else {
      defaultBgColor = isDark
          ? theme.colorScheme.surfaceVariant
          : theme.colorScheme.surface;
      defaultTextColor = theme.colorScheme.onSurface;
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? defaultBgColor,
          foregroundColor: textColor ?? defaultTextColor,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize ?? 20,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
