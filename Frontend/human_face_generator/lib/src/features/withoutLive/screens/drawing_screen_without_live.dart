import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:human_face_generator/src/constants/colors.dart';
import 'package:human_face_generator/src/features/authentication/screens/profile/profile_screen.dart';
import 'package:human_face_generator/src/features/withoutLive/models/drawing_point_without_live.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class DrawingScreenWithoutLive extends StatefulWidget {
  const DrawingScreenWithoutLive({super.key});

  @override
  State<DrawingScreenWithoutLive> createState() => _DrawingRoomScreenState();
}

class _DrawingRoomScreenState extends State<DrawingScreenWithoutLive> {
  var availableColors = [
    Colors.black,
    Colors.red,
    Colors.amber,
    Colors.blue,
    Colors.green,
    Colors.brown,
    Colors.pink,
    Colors.indigo,
  ];

  var historyDrawingPoints = <DrawingPointWithoutLive>[];
  var drawingPoints = <DrawingPointWithoutLive>[];

  var selectedColor = Colors.black;
  var selectedWidth = 2.0;

  DrawingPointWithoutLive? currentDrawingPoint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(
              LineAwesomeIcons.angle_left,
              color: tWhiteColor,
            ),
            onPressed: () => Get.back()),
        title: Text(
          "Drawing Focus Mode",
          style: GoogleFonts.poppins(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: tWhiteColor,
          ),
        ),
        backgroundColor: tPrimaryColor,
      ),
      body: Stack(
        children: [
          /// Canvas
          GestureDetector(
            onPanStart: (details) {
              setState(() {
                currentDrawingPoint = DrawingPointWithoutLive(
                  id: DateTime.now().microsecondsSinceEpoch,
                  offsets: [
                    details.localPosition,
                  ],
                  color: selectedColor,
                  width: selectedWidth,
                );

                if (currentDrawingPoint == null) return;
                drawingPoints.add(currentDrawingPoint!);
                historyDrawingPoints = List.of(drawingPoints);
              });
            },
            onPanUpdate: (details) {
              setState(() {
                if (currentDrawingPoint == null) return;

                currentDrawingPoint = currentDrawingPoint?.copyWith(
                  offsets: currentDrawingPoint!.offsets
                    ..add(details.localPosition),
                );
                drawingPoints.last = currentDrawingPoint!;
                historyDrawingPoints = List.of(drawingPoints);
              });
            },
            onPanEnd: (_) {
              currentDrawingPoint = null;
            },
            child: CustomPaint(
              painter: DrawingPainterWithoutLive(
                drawingPoints: drawingPoints,
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            ),
          ),

          /// color pallet
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 16,
            right: 16,
            child: SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: availableColors.length,
                separatorBuilder: (_, __) {
                  return const SizedBox(width: 8);
                },
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColor = availableColors[index];
                      });
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: availableColors[index],
                        shape: BoxShape.circle,
                      ),
                      foregroundDecoration: BoxDecoration(
                        border: selectedColor == availableColors[index]
                            ? Border.all(color: tPrimaryColor, width: 4)
                            : null,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          /// pencil size
          Positioned(
            top: MediaQuery.of(context).padding.top + 80,
            right: 0,
            bottom: 150,
            child: RotatedBox(
              quarterTurns: 3, // 270 degree
              child: Slider(
                value: selectedWidth,
                thumbColor: tPrimaryColor,
                activeColor: tPrimaryColor,
                secondaryActiveColor: tCardBgColor,
                min: 1,
                max: 20,
                onChanged: (value) {
                  setState(() {
                    selectedWidth = value;
                  });
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: tPrimaryColor,
            heroTag: "Undo",
            onPressed: () {
              if (drawingPoints.isNotEmpty && historyDrawingPoints.isNotEmpty) {
                setState(() {
                  drawingPoints.removeLast();
                });
              }
            },
            child: const Icon(Icons.undo),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            backgroundColor: tPrimaryColor,
            heroTag: "Redo",
            onPressed: () {
              setState(() {
                if (drawingPoints.length < historyDrawingPoints.length) {
                  // 6 length 7
                  final index = drawingPoints.length;
                  drawingPoints.add(historyDrawingPoints[index]);
                }
              });
            },
            child: const Icon(Icons.redo),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            backgroundColor: tPrimaryColor,
            heroTag: "Clear",
            onPressed: () {
              setState(() {
                drawingPoints.clear();
              });
            },
            child: const Icon(Icons.clear_all),
          ),
        ],
      ),
    );
  }
}

class DrawingPainterWithoutLive extends CustomPainter {
  final List<DrawingPointWithoutLive> drawingPoints;

  DrawingPainterWithoutLive({required this.drawingPoints});

  @override
  void paint(Canvas canvas, Size size) {
    for (var drawingPoint in drawingPoints) {
      final paint = Paint()
        ..color = drawingPoint.color
        ..isAntiAlias = true
        ..strokeWidth = drawingPoint.width
        ..strokeCap = StrokeCap.round;

      for (var i = 0; i < drawingPoint.offsets.length; i++) {
        var notLastOffset = i != drawingPoint.offsets.length - 1;

        if (notLastOffset) {
          final current = drawingPoint.offsets[i];
          final next = drawingPoint.offsets[i + 1];
          canvas.drawLine(current, next, paint);
        } else {
          /// we do nothing
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
