import 'package:flutter/material.dart';
import '../models/formula.dart';
import '../services/formula_service.dart';
import '../services/favorites_service.dart';
import '../widgets/formula_card.dart';
import 'calculator_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FormulaService _formulaService = FormulaService();
  final FavoritesService _favoritesService = FavoritesService();
  List<Formula> _favoriteFormulas = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _favoritesService.loadFavorites();
    await _formulaService.loadFormulas();
    _updateFavorites();
  }

  void _updateFavorites() {
    final favoriteIds = _favoritesService.getFavorites();
    _favoriteFormulas = favoriteIds
        .map((id) => _formulaService.getFormulaById(id))
        .where((formula) => formula != null)
        .cast<Formula>()
        .toList();
    setState(() {});
  }

  void _toggleFavorite(String formulaId) async {
    await _favoritesService.toggleFavorite(formulaId);
    _updateFavorites();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранное'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: _favoriteFormulas.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Нет избранных формул',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Добавьте формулы в избранное,\nнажав на иконку сердца',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _favoriteFormulas.length,
              itemBuilder: (context, index) {
                final formula = _favoriteFormulas[index];
                return FormulaCard(
                  formula: formula,
                  onTap: () => _openCalculator(formula),
                  isFavorite: true,
                  onFavoriteToggle: () => _toggleFavorite(formula.id),
                );
              },
            ),
    );
  }
}
