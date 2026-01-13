import 'dart:math';
import 'package:flutter/material.dart';

enum ObstacleType {
  cloud,
  bird,
}

class Obstacle {
  double x;
  double y;
  final double width;
  final double height;
  final ObstacleType type;
  final Color color;

  Obstacle({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.type,
    required this.color,
  });

  static Obstacle createRandom(double screenWidth, double screenHeight) {
    final random = Random();
    final type = ObstacleType.values[random.nextInt(ObstacleType.values.length)];

    double width, height;
    Color color;

    switch (type) {
      case ObstacleType.cloud:
        width = 60.0 + random.nextDouble() * 40.0;
        height = 40.0 + random.nextDouble() * 20.0;
        color = Colors.white.withValues(alpha: 0.8);
        break;
      case ObstacleType.bird:
        width = 30.0 + random.nextDouble() * 20.0;
        height = 20.0 + random.nextDouble() * 10.0;
        color = Colors.brown;
        break;
    }

    return Obstacle(
      x: screenWidth,
      y: random.nextDouble() * (screenHeight - height - 100) + 50,
      width: width,
      height: height,
      type: type,
      color: color,
    );
  }

  void update(double delta, double speed) {
    x -= speed * delta;
  }

  bool isOffScreen() {
    return x + width < 0;
  }

  bool collidesWith(double planeX, double planeY, double planeSize) {
    return x < planeX + planeSize &&
           x + width > planeX &&
           y < planeY + planeSize &&
           y + height > planeY;
  }
}
