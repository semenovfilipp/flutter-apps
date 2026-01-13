import 'dart:ui';

class Obstacle {
  final Rect rect;
  final Color color;

  Obstacle({
    required this.rect,
    this.color = const Color(0xFF4CAF50),
  });

  bool contains(Offset point) {
    return rect.contains(point);
  }
}
