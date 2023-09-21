import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:face_generator_fyp/models/drawingArea.dart';

class MyCustomPainter extends CustomPainter {
  List<DrawingArea?> points;

  MyCustomPainter({required List<DrawingArea?> points}) : points = points.toList();

  @override
  void paint(Canvas canvas, Size size) {
    Paint background = Paint()..color = Colors.black;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, background);
    canvas.clipRect(rect);

    for (int x = 0; x < points.length - 1; x++) {
      if (points[x] != null && points[x + 1] != null) {
        canvas.drawLine(
            points[x]!.point!, points[x + 1]!.point!, points[x]!.areaPaint);
      } else if (points[x] != null && points[x + 1] == null) {
        canvas.drawPoints(
            PointMode.points, [points[x]!.point!], points[x]!.areaPaint);
      }
    }
  }
  @override
  bool shouldRepaint(MyCustomPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}