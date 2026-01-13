import 'package:flutter/material.dart';
import '../models/ball.dart';
import '../models/obstacle.dart';

class GameCanvas extends StatelessWidget {
  final Ball ball;
  final List<Obstacle> obstacles;

  const GameCanvas({
    super.key,
    required this.ball,
    required this.obstacles,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GamePainter(ball: ball, obstacles: obstacles),
      size: Size.infinite,
    );
  }
}

class GamePainter extends CustomPainter {
  final Ball ball;
  final List<Obstacle> obstacles;

  GamePainter({
    required this.ball,
    required this.obstacles,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var obstacle in obstacles) {
      final paint = Paint()
        ..color = obstacle.color
        ..style = PaintingStyle.fill;
      canvas.drawRect(obstacle.rect, paint);
    }

    final ballPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    canvas.drawCircle(ball.position, ball.radius, ballPaint);

    final ballBorder = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(ball.position, ball.radius, ballBorder);
  }

  @override
  bool shouldRepaint(GamePainter oldDelegate) => true;
}
