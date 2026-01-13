import 'dart:ui';

class Ball {
  Offset position;
  Offset velocity;
  double radius;
  bool isLaunched;

  Ball({
    required this.position,
    required this.velocity,
    this.radius = 15.0,
    this.isLaunched = false,
  });

  void reset(Offset startPosition) {
    position = startPosition;
    velocity = const Offset(0, 0);
    isLaunched = false;
  }

  void launch(Offset direction) {
    velocity = direction;
    isLaunched = true;
  }

  void updatePosition(double deltaTime) {
    if (!isLaunched) return;
    position = Offset(
      position.dx + velocity.dx * deltaTime,
      position.dy + velocity.dy * deltaTime,
    );
  }
}
