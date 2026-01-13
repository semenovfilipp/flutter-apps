import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/animal.dart';

class AnimalDatabaseService {
  static final AnimalDatabaseService _instance = AnimalDatabaseService._internal();
  factory AnimalDatabaseService() => _instance;
  AnimalDatabaseService._internal();

  List<Animal>? _animals;

  Future<List<Animal>> getAllAnimals() async {
    if (_animals != null) {
      return _animals!;
    }

    final String jsonString = await rootBundle.loadString(
      'lib/data/animals.json',
    );
    final List<dynamic> jsonData = json.decode(jsonString);
    _animals = jsonData.map((json) => Animal.fromJson(json)).toList();
    return _animals!;
  }

  Future<Animal?> getAnimalById(String id) async {
    final animals = await getAllAnimals();
    try {
      return animals.firstWhere((animal) => animal.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Animal>> searchAnimals(String query) async {
    if (query.isEmpty) {
      return getAllAnimals();
    }

    final animals = await getAllAnimals();
    final lowercaseQuery = query.toLowerCase();

    return animals.where((animal) {
      return animal.name.toLowerCase().contains(lowercaseQuery) ||
          animal.scientificName.toLowerCase().contains(lowercaseQuery) ||
          animal.category.toLowerCase().contains(lowercaseQuery) ||
          animal.habitat.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  Future<List<Animal>> getAnimalsByCategory(String category) async {
    final animals = await getAllAnimals();
    return animals.where((animal) => animal.category == category).toList();
  }

  Future<List<String>> getAllCategories() async {
    final animals = await getAllAnimals();
    final categories = animals.map((animal) => animal.category).toSet().toList();
    categories.sort();
    return categories;
  }
}
