import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static final FavoritesService _instance = FavoritesService._internal();
  factory FavoritesService() => _instance;
  FavoritesService._internal();

  static const String _favoritesKey = 'animal_pedia_favorites';
  Set<String> _favoriteIds = {};
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedFavorites = prefs.getStringList(_favoritesKey);
    if (savedFavorites != null) {
      _favoriteIds = savedFavorites.toSet();
    }
    _initialized = true;
  }

  Future<void> toggleFavorite(String animalId) async {
    await initialize();

    if (_favoriteIds.contains(animalId)) {
      _favoriteIds.remove(animalId);
    } else {
      _favoriteIds.add(animalId);
    }

    await _saveFavorites();
  }

  Future<void> addFavorite(String animalId) async {
    await initialize();
    _favoriteIds.add(animalId);
    await _saveFavorites();
  }

  Future<void> removeFavorite(String animalId) async {
    await initialize();
    _favoriteIds.remove(animalId);
    await _saveFavorites();
  }

  Future<bool> isFavorite(String animalId) async {
    await initialize();
    return _favoriteIds.contains(animalId);
  }

  Future<Set<String>> getAllFavorites() async {
    await initialize();
    return Set.from(_favoriteIds);
  }

  Future<int> getFavoritesCount() async {
    await initialize();
    return _favoriteIds.length;
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, _favoriteIds.toList());
  }

  Future<void> clearAllFavorites() async {
    await initialize();
    _favoriteIds.clear();
    await _saveFavorites();
  }
}
