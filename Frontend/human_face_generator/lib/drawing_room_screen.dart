import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:human_face_generator/custom_painter.dart';
import 'package:human_face_generator/drawing_point.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:http/http.dart' as http;

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

  Widget imageOutput = Container();

  final ImagePicker picker = ImagePicker();
  File? image;

  Future<void> chooseImage() async {
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      final File pickedImage = File(file.path);
      final decodedImage = await decodeImageFromFile(pickedImage);
      if (decodedImage != null && decodedImage.width == 256 && decodedImage.height == 256) {
        setState(() {
          image = pickedImage;
        });
      } else {
        // Show a dialog box indicating the image is not supported
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Image Not Supported'),
              content: Text('Please choose an image with dimensions 256x256.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  Future<ui.Image?> decodeImageFromFile(File imageFile) async {
    final Uint8List bytes = await imageFile.readAsBytes();
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(bytes, (ui.Image img) {
      completer.complete(img);
    });
    return completer.future;
  }

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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(255, 255, 255, 1),
              Color.fromRGBO(255, 255, 255, 1),
              Color.fromRGBO(255, 255, 255, 1),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: image !=null ? Image.file(image!) : Container(
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
                    ), // Set the background color to white
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
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                //width: 500,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 0, 0, 0),
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
                    width: 10,
                  ),
                  IconButton(
                    onPressed: () {
                      if (drawingPoints.length < historyDrawingPoints.length) {
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
                    width: 10,
                  ),
                  IconButton(
                    onPressed: () {
                      drawingPoints.clear();
                      historyDrawingPoints.clear();
                      image = null;
                    },
                    icon: const Icon(
                      Icons.clear_all,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    onPressed: (){
                    },
                    icon: const Icon(
                      Icons.save_alt_outlined,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                      onPressed: () {
                        chooseImage();
                      },
                      icon: const Icon(
                        Icons.file_upload_outlined,
                        color: Colors.white,
                      ))
                ]),
              ),
              Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: SizedBox(
                  height: 256,
                  width: 256,
                  child: imageOutput,
                ),
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}



void showSaveDialog(BuildContext context, bool isSuccess, String errorMessage) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: isSuccess ? Text('Success') : Text('Error'),
        content: isSuccess
            ? Text('Image saved to gallery')
            : Text('Error saving image: $errorMessage'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

