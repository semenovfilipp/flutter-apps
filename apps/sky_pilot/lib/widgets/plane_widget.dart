import 'package:flutter/material.dart';
import '../models/plane_type.dart';

class PlaneWidget extends StatelessWidget {
  final PlaneModel plane;

  const PlaneWidget({super.key, required this.plane});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(plane.size, plane.size),
      painter: PlanePainter(color: plane.color),
    );
  }
}

class PlanePainter extends CustomPainter {
  final Color color;

  PlanePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(size.width * 0.8, size.height * 0.5);
    path.lineTo(size.width * 0.2, size.height * 0.3);
    path.lineTo(0, size.height * 0.5);
    path.lineTo(size.width * 0.2, size.height * 0.7);
    path.close();

    canvas.drawPath(path, paint);

    final wingPaint = Paint()
      ..color = color.withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;

    final wingPath = Path();
    wingPath.moveTo(size.width * 0.5, size.height * 0.5);
    wingPath.lineTo(size.width * 0.3, size.height * 0.2);
    wingPath.lineTo(size.width * 0.4, size.height * 0.5);
    wingPath.close();

    canvas.drawPath(wingPath, wingPaint);

    wingPath.reset();
    wingPath.moveTo(size.width * 0.5, size.height * 0.5);
    wingPath.lineTo(size.width * 0.3, size.height * 0.8);
    wingPath.lineTo(size.width * 0.4, size.height * 0.5);
    wingPath.close();

    canvas.drawPath(wingPath, wingPaint);
  }

  @override
  bool shouldRepaint(PlanePainter oldDelegate) => color != oldDelegate.color;
}
