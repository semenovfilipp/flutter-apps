class Animal {
  final String id;
  final String name;
  final String scientificName;
  final String category;
  final String habitat;
  final String diet;
  final String description;
  final List<String> facts;
  final String imageUrl;
  final String conservationStatus;
  final String lifespan;
  final String weight;
  final String length;

  Animal({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.category,
    required this.habitat,
    required this.diet,
    required this.description,
    required this.facts,
    required this.imageUrl,
    required this.conservationStatus,
    required this.lifespan,
    required this.weight,
    required this.length,
  });

  factory Animal.fromJson(Map<String, dynamic> json) {
    return Animal(
      id: json['id'] as String,
      name: json['name'] as String,
      scientificName: json['scientificName'] as String,
      category: json['category'] as String,
      habitat: json['habitat'] as String,
      diet: json['diet'] as String,
      description: json['description'] as String,
      facts: List<String>.from(json['facts'] as List),
      imageUrl: json['imageUrl'] as String,
      conservationStatus: json['conservationStatus'] as String,
      lifespan: json['lifespan'] as String,
      weight: json['weight'] as String,
      length: json['length'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'scientificName': scientificName,
      'category': category,
      'habitat': habitat,
      'diet': diet,
      'description': description,
      'facts': facts,
      'imageUrl': imageUrl,
      'conservationStatus': conservationStatus,
      'lifespan': lifespan,
      'weight': weight,
      'length': length,
    };
  }
}
