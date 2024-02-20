import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:human_face_generator/custom_painter.dart';
import 'package:human_face_generator/drawing_point.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

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

  Widget? imageOutput = Container();

  bool isSavedPressed = false;
  var sketchSaveBytes;
  Uint8List? convertedBytes;

  final GlobalKey imageKey = GlobalKey();

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

  void saveToImageGallary(List<DrawingPoint?> points) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromPoints(const Offset(0.0, 0.0), const Offset(256, 256)),
    );
    Paint paint = Paint()
      ..color = const ui.Color.fromARGB(255, 0, 0, 0)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;
    final paint2 = Paint()
      ..style = PaintingStyle.fill
      ..color = const ui.Color.fromARGB(255, 255, 255, 255);
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
    sketchSaveBytes = Uint8List.view(pngBytes!.buffer);
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
      imageOutput = RepaintBoundary(
        key: imageKey,
        child: SizedBox(
          width: 256,
          height: 256,
          child: Image.memory(convertedBytes, fit: BoxFit.contain),
        ),
      );
    });
  }

  void showImageSavedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Image Saved'),
          content: const Text('Image Stored In Gallery.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showImageNotSavedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Sketch Found'),
          content: const Text('Draw A Sketch First.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                            currentDrawingPoint = currentDrawingPoint?.copyWith(
                              offsets: currentDrawingPoint!.offsets
                                ..add(details.localPosition),
                            );
                            drawingPoints.last = currentDrawingPoint!;
                            historyDrawingPoints = List.of(drawingPoints);
                          });
                        },
                        onPanEnd: (details) {
                          saveToImage(drawingPoints);
                          saveToImageGallary(drawingPoints);
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
                    const SizedBox(height: 50),
                    Container(
                      width: 256,
                      height: 256,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.0),
                      ),
                      child: imageOutput != null
                          ? imageOutput
                          : Center(
                              child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("No AI generated image yet!"),
                                Text("Draw a face sketch first!")
                              ],
                            )),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 256,
                      width: 40,
                      decoration: const BoxDecoration(
                        color: Colors.brown,
                        borderRadius: BorderRadius.all(
                          Radius.circular(0),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                            height: 0,
                          ),
                          IconButton(
                            onPressed: () {
                              if (drawingPoints.length <
                                  historyDrawingPoints.length) {
                                // 6 length 7
                                final index = drawingPoints.length;
                                drawingPoints.add(historyDrawingPoints[index]);
                                saveToImage(drawingPoints);
                              }
                            },
                            icon: const Icon(
                              Icons.redo,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                          const SizedBox(
                            height: 0,
                          ),
                          IconButton(
                            onPressed: () {
                              drawingPoints.clear();
                              historyDrawingPoints.clear();
                              //image = null;
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 0,
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (drawingPoints.isNotEmpty) {
                                  final result = ImageGallerySaver.saveImage(
                                      Uint8List.fromList(sketchSaveBytes));
                                  if (result != null) {
                                    showImageSavedDialog(context);
                                  } else {
                                    showImageNotSavedDialog(context);
                                  }
                                } else {
                                  showImageNotSavedDialog(context);
                                }
                              });
                            },
                            icon: const Icon(
                              Icons.save,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 0,
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
                    const SizedBox(height: 50),
                    Container(
                      height: 256,
                      width: 40,
                      decoration: const BoxDecoration(
                        color: Colors.brown,
                        borderRadius: BorderRadius.all(
                          Radius.circular(0),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                imageOutput = null;
                              });
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 0,
                          ),
                          IconButton(
                            onPressed: () async {
                              if (imageOutput != null) {
                                RenderRepaintBoundary boundary =
                                    imageKey.currentContext!.findRenderObject()
                                        as RenderRepaintBoundary;
                                ui.Image image =
                                    await boundary.toImage(pixelRatio: 3.0);
                                ByteData? byteData = await image.toByteData(
                                    format: ui.ImageByteFormat.png);
                                Uint8List pngBytes =
                                    byteData!.buffer.asUint8List();

                                // Save the image to the device's gallery
                                final result =
                                    await ImageGallerySaver.saveImage(
                                        Uint8List.fromList(pngBytes));

                                // Check if the image was saved successfully
                                if (result != null) {
                                  showImageSavedDialog(context);
                                } else {
                                  showImageNotSavedDialog(context);
                                }
                              } else {
                                showImageNotSavedDialog(context);
                              }
                            },
                            icon: const Icon(
                              Icons.save,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
