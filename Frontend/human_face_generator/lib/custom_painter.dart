
import 'package:flutter/material.dart';
import 'package:human_face_generator/drawing_point.dart';

class DrawingPainter extends CustomPainter {
  final List<DrawingPoint> drawingPoints;

  DrawingPainter({required this.drawingPoints});

  @override
  @override
  void paint(Canvas canvas, Size size) {
    for (var drawingPoint in drawingPoints) {
      final paint = Paint()
        ..color = drawingPoint.color
        ..isAntiAlias = true
        ..strokeWidth = drawingPoint.width
        ..strokeCap = StrokeCap.round;

      for (var i = 0; i < drawingPoint.offsets.length - 1; i++) {
        final current = drawingPoint.offsets[i];
        final next = drawingPoint.offsets[i + 1];

        // Ensure the points stay within the 256x256 area
        if (current.dx >= 0 &&
            current.dx <= 256 &&
            current.dy >= 0 &&
            current.dy <= 256 &&
            next.dx >= 0 &&
            next.dx <= 256 &&
            next.dy >= 0 &&
            next.dy <= 256) {
          canvas.drawLine(current, next, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
