import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:human_face_generator/custom_painter.dart';
import 'package:human_face_generator/drawing_point.dart';

class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  var avaiableColor = [
    Colors.black,
    Colors.red,
    Colors.amber,
    Colors.blue,
    Colors.green,
    Colors.brown,
  ];

  var selectedColor = Colors.black;
  var selectedWidth = 2.0;

  var historyDrawingPoints = <DrawingPoint>[];
  var drawingPoints = <DrawingPoint>[];
  DrawingPoint? currentDrawingPoint;

  Widget imageOutput = Container();

  void saveToImage(List<DrawingPoint?> points) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromPoints(const Offset(0.0, 0.0), const Offset(256, 256)),
    );
    Paint paint = Paint()
      ..color = const ui.Color.fromARGB(255, 255, 255, 255)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;
    final paint2 = Paint()
      ..style = PaintingStyle.fill
      ..color = const ui.Color.fromARGB(255, 0, 0, 0);
    canvas.drawRect(const Rect.fromLTWH(0, 0, 256, 256), paint2);

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        for (int j = 0; j < points[i]!.offsets.length - 1; j++) {
          canvas.drawLine(
            points[i]!.offsets[j],
            points[i]!.offsets[j + 1],
            paint,
          );
        }
      }
    }
    final picture = recorder.endRecording();
    final img = await picture.toImage(256, 256);

    final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);
    final listBytes = Uint8List.view(pngBytes!.buffer);

    //File file = await writeBytes(listBytes);
    String base64 = base64Encode(listBytes);
    fetchResponse(base64);
  }

  void fetchResponse(var base64Image) async {
    var data = {"Image": base64Image};
    var url = Uri.parse("http://192.168.43.199:5000/predict");

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Connection': "Keep-Alive",
    };
    var body = json.encode(data);
    try {
      var response = await http.post(url, body: body, headers: headers);

      final Map<String, dynamic> responseData = json.decode(response.body);
      String outputBytes = responseData['Image'];
      displayResponseImage(outputBytes.substring(2, outputBytes.length - 1));
    } catch (e) {
      // ignore: avoid_print
      // Display a Snackbar when an error occurs
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Server is down. Please try again later.'),
        ),
      );
      print(" *Error has Occured: $e");
      return null;
    }
  }

  void displayResponseImage(String bytes) async {
    Uint8List convertedBytes = base64Decode(bytes);
    setState(() {
      imageOutput = SizedBox(
          width: 256,
          height: 256,
          child: Image.memory(convertedBytes, fit: BoxFit.contain));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: SizedBox(
                                height: 250,
                                child: ListView.separated(
                                  scrollDirection: Axis.vertical,
                                  itemCount: avaiableColor.length,
                                  separatorBuilder: (_, __) {
                                    return const SizedBox(
                                      height: 10,
                                    );
                                  },
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedColor = avaiableColor[index];
                                        });
                                      },
                                      child: Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                            color: avaiableColor[index],
                                            shape: BoxShape.circle),
                                        foregroundDecoration: BoxDecoration(
                                            border: selectedColor ==
                                                    avaiableColor[index]
                                                ? Border.all(
                                                    color: Colors.brown,
                                                    width: 4)
                                                : null,
                                            shape: BoxShape.circle),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 256,
                            height: 256,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(0),
                              ),
                              color: Colors.white,
                              border: Border.all(
                                color: const Color.fromARGB(
                                    255, 0, 0, 0), // Set the border color here
                                width: 1, // Set the border width here
                              ),
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

                                  currentDrawingPoint =
                                      currentDrawingPoint?.copyWith(
                                    offsets: currentDrawingPoint!.offsets
                                      ..add(details.localPosition),
                                  );
                                  drawingPoints.last = currentDrawingPoint!;
                                  historyDrawingPoints = List.of(drawingPoints);
                                });
                              },
                              onPanEnd: (details) {
                                saveToImage(drawingPoints);
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
                        ],
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 250,
                              width: 50,
                              decoration: const BoxDecoration(
                                color: Colors.brown,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      if (drawingPoints.isNotEmpty &&
                                          historyDrawingPoints.isNotEmpty) {
                                        setState(() {
                                          drawingPoints.removeLast();
                                          saveToImage(drawingPoints);
                                        });
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.undo,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      if (drawingPoints.length <
                                          historyDrawingPoints.length) {
                                        // 6 length 7
                                        final index = drawingPoints.length;
                                        drawingPoints
                                            .add(historyDrawingPoints[index]);
                                        saveToImage(drawingPoints);
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.redo,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      drawingPoints.clear();
                                      historyDrawingPoints.clear();
                                      //image = null;
                                    },
                                    icon: const Icon(
                                      Icons.clear_all,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.save_alt_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      //chooseImage();
                                    },
                                    icon: const Icon(
                                      Icons.file_upload_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.green, // Color of the second container
                  // Add your widgets for the second container here
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
