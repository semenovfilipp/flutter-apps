import 'package:flutter/material.dart';
import '../models/obstacle.dart';

class ObstacleWidget extends StatelessWidget {
  final Obstacle obstacle;

  const ObstacleWidget({super.key, required this.obstacle});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(obstacle.width, obstacle.height),
      painter: ObstaclePainter(
        type: obstacle.type,
        color: obstacle.color,
      ),
    );
  }
}

class ObstaclePainter extends CustomPainter {
  final ObstacleType type;
  final Color color;

  ObstaclePainter({required this.type, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    switch (type) {
      case ObstacleType.cloud:
        _drawCloud(canvas, size, paint);
        break;
      case ObstacleType.bird:
        _drawBird(canvas, size, paint);
        break;
    }
  }

  void _drawCloud(Canvas canvas, Size size, Paint paint) {
    final rect1 = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, size.height * 0.3, size.width * 0.4, size.height * 0.5),
      const Radius.circular(20),
    );
    canvas.drawRRect(rect1, paint);

    final rect2 = RRect.fromRectAndRadius(
      Rect.fromLTWH(
          size.width * 0.2, size.height * 0.1, size.width * 0.5, size.height * 0.6),
      const Radius.circular(25),
    );
    canvas.drawRRect(rect2, paint);

    final rect3 = RRect.fromRectAndRadius(
      Rect.fromLTWH(
          size.width * 0.5, size.height * 0.2, size.width * 0.4, size.height * 0.5),
      const Radius.circular(20),
    );
    canvas.drawRRect(rect3, paint);
  }

  void _drawBird(Canvas canvas, Size size, Paint paint) {
    final path = Path();

    path.moveTo(size.width * 0.5, size.height * 0.5);
    path.quadraticBezierTo(
      size.width * 0.2,
      0,
      0,
      size.height * 0.3,
    );

    path.moveTo(size.width * 0.5, size.height * 0.5);
    path.quadraticBezierTo(
      size.width * 0.8,
      0,
      size.width,
      size.height * 0.3,
    );

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(ObstaclePainter oldDelegate) =>
      type != oldDelegate.type || color != oldDelegate.color;
}
