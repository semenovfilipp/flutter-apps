import 'package:flutter/material.dart';
import '../models/animal.dart';
import '../services/animal_database_service.dart';
import '../widgets/animal_card.dart';
import 'animal_details_screen.dart';
import 'search_screen.dart';
import 'favorites_screen.dart';
import 'about_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AnimalDatabaseService _databaseService = AnimalDatabaseService();
  List<Animal> _animals = [];
  List<String> _categories = [];
  String? _selectedCategory;
  bool _isLoading = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    final animals = await _databaseService.getAllAnimals();
    final categories = await _databaseService.getAllCategories();

    if (mounted) {
      setState(() {
        _animals = animals;
        _categories = categories;
        _isLoading = false;
      });
    }
  }

  List<Animal> get _filteredAnimals {
    if (_selectedCategory == null) {
      return _animals;
    }
    return _animals.where((animal) => animal.category == _selectedCategory).toList();
  }

  void _navigateToDetails(Animal animal) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnimalDetailsScreen(animal: animal),
      ),
    ).then((_) => setState(() {}));
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          FilterChip(
            label: const Text('All'),
            selected: _selectedCategory == null,
            onSelected: (selected) {
              setState(() {
                _selectedCategory = null;
              });
            },
          ),
          const SizedBox(width: 8),
          ..._categories.map((category) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(category),
                selected: _selectedCategory == category,
                onSelected: (selected) {
                  setState(() {
                    _selectedCategory = selected ? category : null;
                  });
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAnimalList() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_filteredAnimals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pets,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No animals found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        itemCount: _filteredAnimals.length,
        itemBuilder: (context, index) {
          final animal = _filteredAnimals[index];
          return AnimalCard(
            animal: animal,
            onTap: () => _navigateToDetails(animal),
            onFavoriteChanged: () => setState(() {}),
          );
        },
      ),
    );
  }

  Widget _buildHomeContent() {
    return Column(
      children: [
        _buildCategoryFilter(),
        Expanded(
          child: _buildAnimalList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      _buildHomeContent(),
      const SearchScreen(),
      FavoritesScreen(key: ValueKey(_currentIndex)),
      const AboutScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.pets,
              color: Colors.green[700],
            ),
            const SizedBox(width: 8),
            const Text('AnimalPedia'),
          ],
        ),
        elevation: 2,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green[700],
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
        ],
      ),
    );
  }
}
