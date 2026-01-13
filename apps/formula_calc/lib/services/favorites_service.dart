import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static final FavoritesService _instance = FavoritesService._internal();
  factory FavoritesService() => _instance;
  FavoritesService._internal();

  static const String _favoritesKey = 'favorite_formulas';
  Set<String> _favorites = {};
  bool _isLoaded = false;

  Future<void> loadFavorites() async {
    if (_isLoaded) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? savedFavorites = prefs.getStringList(_favoritesKey);
      _favorites = savedFavorites?.toSet() ?? {};
      _isLoaded = true;
    } catch (e) {
      print('Error loading favorites: $e');
      _favorites = {};
    }
  }

  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_favoritesKey, _favorites.toList());
    } catch (e) {
      print('Error saving favorites: $e');
    }
  }

  bool isFavorite(String formulaId) {
    return _favorites.contains(formulaId);
  }

  Future<void> toggleFavorite(String formulaId) async {
    if (_favorites.contains(formulaId)) {
      _favorites.remove(formulaId);
    } else {
      _favorites.add(formulaId);
    }
    await _saveFavorites();
  }

  List<String> getFavorites() {
    return List.unmodifiable(_favorites);
  }

  int get count => _favorites.length;
}
