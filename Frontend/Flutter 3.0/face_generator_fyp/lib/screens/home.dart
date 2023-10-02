import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:face_generator_fyp/models/drawingArea.dart';
import 'package:face_generator_fyp/widgets/custom_painter.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<DrawingArea?> points = [];
  Widget imageOutput = Container();
  bool isErasing = false;

  void saveToImage(List<DrawingArea?> points) async {
    final recorder = ui.PictureRecorder();
    final canvas =
        Canvas(recorder, Rect.fromPoints(const Offset(0.0, 0.0), const Offset(200, 200)));
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;
    final paint2 = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black;
    canvas.drawRect(const Rect.fromLTWH(0, 0, 256, 256), paint2);

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null)
        {
          canvas.drawLine(points[i]!.point!, points[i + 1]!.point!, paint);
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
    var url = Uri.parse("http://192.168.47.56:5000/predict");

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
        body: Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Color.fromRGBO(255, 255, 255, 1.0),
                Color.fromRGBO(255, 255, 255, 1.0),
                Color.fromRGBO(255, 255, 255, 1.0)
              ])),
        ),
        Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  width: 256,
                  height: 256,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(0),
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.0),
                            blurRadius: 510,
                            spreadRadius: 1)
                      ]),
                  child: GestureDetector(
                    onPanDown: (details) {
                      setState(() {
                        points.add(DrawingArea(
                            point: details.localPosition,
                            areaPaint: Paint()
                              ..strokeCap = StrokeCap.round
                              ..isAntiAlias = true
                              ..color = isErasing ? Colors.black : Colors.white
                              ..strokeWidth = 2.0));
                      });
                    },
                    onPanUpdate: (details) {
                      setState(() {
                        points.add(DrawingArea(
                            point: details.localPosition,
                            areaPaint: Paint()
                              ..strokeCap = StrokeCap.round
                              ..isAntiAlias = true
                              ..color = isErasing ? Colors.black : Colors.white
                              ..strokeWidth = 2.0));
                      });
                    },
                    onPanEnd: (details) {
                      saveToImage(points);
                      setState(
                        () {
                          points.add(null);
                        },
                      );
                    },
                    child: SizedBox.expand(
                        child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      child: CustomPaint(
                        painter: MyCustomPainter(points: points),
                      ),
                    )),
                  ),
                )),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          points.clear();
                        });
                      },
                      child: const Text('Clear Input', style: TextStyle(color: Colors.black),),
                    ),
                    const SizedBox(width: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isErasing = !isErasing;
                        });
                      },
                      child: Text(isErasing ? 'Draw' : 'Erase', style: const TextStyle(color: Colors.black),),
                    ),
                  ],

                )),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  // ignore: unnecessary_null_comparison
                  visible: imageOutput != null,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        imageOutput = Container();
                      });
                    },
                    child: const Text('Clear Output', style: TextStyle(color: Colors.black)),
                  ),
                ),
                const SizedBox(width: 20.0),
                Visibility(
                  // ignore: unnecessary_null_comparison
                  visible: imageOutput != null,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Save Image', style: TextStyle(color: Colors.black)),
                  ),
                ),
              ],
            ),
          ],
        ))
      ],
    ));
  }
}
