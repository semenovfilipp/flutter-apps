class PhysicsConfig {
  double gravity;
  double bounceDamping;
  double friction;

  PhysicsConfig({
    this.gravity = 500.0,
    this.bounceDamping = 0.8,
    this.friction = 0.99,
  });

  PhysicsConfig copyWith({
    double? gravity,
    double? bounceDamping,
    double? friction,
  }) {
    return PhysicsConfig(
      gravity: gravity ?? this.gravity,
      bounceDamping: bounceDamping ?? this.bounceDamping,
      friction: friction ?? this.friction,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gravity': gravity,
      'bounceDamping': bounceDamping,
      'friction': friction,
    };
  }

  factory PhysicsConfig.fromJson(Map<String, dynamic> json) {
    return PhysicsConfig(
      gravity: json['gravity'] ?? 500.0,
      bounceDamping: json['bounceDamping'] ?? 0.8,
      friction: json['friction'] ?? 0.99,
    );
  }
}
