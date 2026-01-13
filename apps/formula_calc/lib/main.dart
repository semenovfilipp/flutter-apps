import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const FormulaCalcApp());
}

class FormulaCalcApp extends StatelessWidget {
  const FormulaCalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FormulaCalc',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
