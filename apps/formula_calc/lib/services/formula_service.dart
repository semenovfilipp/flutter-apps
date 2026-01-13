import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/formula.dart';

class FormulaService {
  static final FormulaService _instance = FormulaService._internal();
  factory FormulaService() => _instance;
  FormulaService._internal();

  List<Formula> _formulas = [];
  bool _isLoaded = false;

  Future<void> loadFormulas() async {
    if (_isLoaded) return;

    try {
      final String response =
          await rootBundle.loadString('lib/data/formulas.json');
      final List<dynamic> data = json.decode(response);
      _formulas = data.map((json) => Formula.fromJson(json)).toList();
      _isLoaded = true;
    } catch (e) {
      print('Error loading formulas: $e');
      _formulas = [];
    }
  }

  List<Formula> getAllFormulas() {
    return List.unmodifiable(_formulas);
  }

  List<Formula> getFormulasBySubject(String subject) {
    return _formulas.where((f) => f.subject == subject).toList();
  }

  Formula? getFormulaById(String id) {
    try {
      return _formulas.firstWhere((f) => f.id == id);
    } catch (e) {
      return null;
    }
  }

  List<String> getSubjects() {
    return _formulas.map((f) => f.subject).toSet().toList();
  }

  String getSubjectDisplayName(String subject) {
    switch (subject) {
      case 'math':
        return 'Математика';
      case 'physics':
        return 'Физика';
      case 'chemistry':
        return 'Химия';
      default:
        return subject;
    }
  }
}
