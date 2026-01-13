class Formula {
  final String id;
  final String name;
  final String subject; // Math, Physics, Chemistry
  final String formulaText;
  final String description;
  final Map<String, String> variables; // variable: description
  final String? example;

  Formula({
    required this.id,
    required this.name,
    required this.subject,
    required this.formulaText,
    required this.description,
    required this.variables,
    this.example,
  });

  factory Formula.fromJson(Map<String, dynamic> json) {
    return Formula(
      id: json['id'] as String,
      name: json['name'] as String,
      subject: json['subject'] as String,
      formulaText: json['formulaText'] as String,
      description: json['description'] as String,
      variables: Map<String, String>.from(json['variables'] as Map),
      example: json['example'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subject': subject,
      'formulaText': formulaText,
      'description': description,
      'variables': variables,
      'example': example,
    };
  }
}

enum Subject {
  math('Математика'),
  physics('Физика'),
  chemistry('Химия');

  final String displayName;
  const Subject(this.displayName);
}
