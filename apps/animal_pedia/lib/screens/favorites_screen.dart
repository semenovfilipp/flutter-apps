import 'package:flutter/material.dart';
import '../models/animal.dart';
import '../services/animal_database_service.dart';
import '../services/favorites_service.dart';
import '../widgets/animal_card.dart';
import 'animal_details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final AnimalDatabaseService _databaseService = AnimalDatabaseService();
  final FavoritesService _favoritesService = FavoritesService();
  List<Animal> _favoriteAnimals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
    });

    final favoriteIds = await _favoritesService.getAllFavorites();
    final allAnimals = await _databaseService.getAllAnimals();

    final favorites = allAnimals
        .where((animal) => favoriteIds.contains(animal.id))
        .toList();

    if (mounted) {
      setState(() {
        _favoriteAnimals = favorites;
        _isLoading = false;
      });
    }
  }

  void _navigateToDetails(Animal animal) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnimalDetailsScreen(animal: animal),
      ),
    ).then((_) => _loadFavorites());
  }

  Future<void> _clearAllFavorites() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Favorites'),
        content: const Text(
          'Are you sure you want to remove all animals from favorites?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _favoritesService.clearAllFavorites();
      await _loadFavorites();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All favorites cleared'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_favoriteAnimals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'No favorites yet',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Tap the heart icon on any animal to add it to favorites',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey[100],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_favoriteAnimals.length} ${_favoriteAnimals.length == 1 ? 'Favorite' : 'Favorites'}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: _clearAllFavorites,
                icon: const Icon(Icons.clear_all),
                label: const Text('Clear All'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadFavorites,
            child: ListView.builder(
              itemCount: _favoriteAnimals.length,
              itemBuilder: (context, index) {
                final animal = _favoriteAnimals[index];
                return AnimalCard(
                  animal: animal,
                  onTap: () => _navigateToDetails(animal),
                  onFavoriteChanged: () => _loadFavorites(),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
