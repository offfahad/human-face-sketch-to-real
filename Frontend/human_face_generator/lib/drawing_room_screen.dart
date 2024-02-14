import 'package:flutter/material.dart';
import 'package:human_face_generator/drawing_point.dart';

class DrawingRoomScreen extends StatefulWidget {
  const DrawingRoomScreen({super.key});

  @override
  State<DrawingRoomScreen> createState() => _DrawingRoomScreenState();
}

class _DrawingRoomScreenState extends State<DrawingRoomScreen> {
  var historyDrawingPoints = <DrawingPoint>[];
  var drawingPoints = <DrawingPoint>[];

  var selectedColor = Colors.black;
  var selectedWidth = 2.0;
  DrawingPoint? currentDrawingPoint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(80, 59, 59, 1),
              Color.fromRGBO(121, 201, 154, 1),
              Color.fromRGBO(168, 168, 168, 1),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Container(
                  width: 256,
                  height: 256,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(0),
                    ),
                    color: Colors.white, // Set the background color to white
                    //boxShadow: [
                      //BoxShadow(
                       // color: Colors.black.withOpacity(0.0),
                        //blurRadius: 10,
                        //spreadRadius: 1,
                      //),
                    //],
                  ),
                  child: GestureDetector(
                    onPanStart: (details) {
                      setState(() {
                        currentDrawingPoint = DrawingPoint(
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
                      painter: DrawingPainter(
                        drawingPoints: drawingPoints,
                      ),
                      size: const Size(256, 256),
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                //width: 300,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  IconButton(
                    onPressed: () {
                      if (drawingPoints.isNotEmpty &&
                          historyDrawingPoints.isNotEmpty) {
                        setState(() {
                          drawingPoints.removeLast();
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.undo,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10,),
                  IconButton(
                    onPressed: () {
                      if (drawingPoints.length < historyDrawingPoints.length) {
                        // 6 length 7
                        final index = drawingPoints.length;
                        drawingPoints.add(historyDrawingPoints[index]);
                      }
                    },
                    icon: const Icon(
                      Icons.redo,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10,),
                  IconButton(
                      onPressed: () {
                        drawingPoints.clear();
                        historyDrawingPoints.clear();
                      },
                      icon: const Icon(Icons.delete))
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}

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
