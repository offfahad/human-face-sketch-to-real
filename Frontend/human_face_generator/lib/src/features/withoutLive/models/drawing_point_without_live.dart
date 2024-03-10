import 'package:flutter/material.dart';

class DrawingPointWithoutLive {
  int id;
  List<Offset> offsets;
  Color color;
  double width;

  DrawingPointWithoutLive({
    this.id = -1,
    this.offsets = const [],
    this.color = Colors.black,
    this.width = 2,
  });

  DrawingPointWithoutLive copyWith({List<Offset>? offsets}) {
    return DrawingPointWithoutLive(
      id: id,
      color: color,
      width: width,
      offsets: offsets ?? this.offsets,
    );
  }
}
