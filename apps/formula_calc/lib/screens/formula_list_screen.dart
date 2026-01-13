import 'package:flutter/material.dart';
import '../models/formula.dart';
import '../services/formula_service.dart';
import '../services/favorites_service.dart';
import '../widgets/formula_card.dart';
import 'calculator_screen.dart';

class FormulaListScreen extends StatefulWidget {
  final String subject;

  const FormulaListScreen({Key? key, required this.subject}) : super(key: key);

  @override
  State<FormulaListScreen> createState() => _FormulaListScreenState();
}

class _FormulaListScreenState extends State<FormulaListScreen> {
  final FormulaService _formulaService = FormulaService();
  final FavoritesService _favoritesService = FavoritesService();
  List<Formula> _formulas = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _favoritesService.loadFavorites();
    _formulas = _formulaService.getFormulasBySubject(widget.subject);
    setState(() {});
  }

  void _toggleFavorite(String formulaId) async {
    await _favoritesService.toggleFavorite(formulaId);
    setState(() {});
  }

  void _openCalculator(Formula formula) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CalculatorScreen(formula: formula),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayName = _formulaService.getSubjectDisplayName(widget.subject);

    return Scaffold(
      appBar: AppBar(
        title: Text(displayName),
        backgroundColor: _getSubjectColor(),
        foregroundColor: Colors.white,
      ),
      body: _formulas.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _formulas.length,
              itemBuilder: (context, index) {
                final formula = _formulas[index];
                return FormulaCard(
                  formula: formula,
                  onTap: () => _openCalculator(formula),
                  isFavorite: _favoritesService.isFavorite(formula.id),
                  onFavoriteToggle: () => _toggleFavorite(formula.id),
                );
              },
            ),
    );
  }

  Color _getSubjectColor() {
    switch (widget.subject) {
      case 'math':
        return Colors.blue;
      case 'physics':
        return Colors.green;
      case 'chemistry':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }
}
