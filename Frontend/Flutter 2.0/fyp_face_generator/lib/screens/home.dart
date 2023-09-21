import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fyp_face_generator/models/drawingarea.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<DrawingArea> points = [];
  Widget imageOutput;
  Widget img1;
  bool isSavedPressed = false;
  var listBytes;
  Uint8List convertedBytes;

  void saveToImage(List<DrawingArea> points) async {
    final recorder = ui.PictureRecorder();
    final canvas =
        Canvas(recorder, Rect.fromPoints(Offset(0.0, 0.0), Offset(200, 200)));
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;
    final paint2 = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black;
    canvas.drawRect(Rect.fromLTWH(0, 0, 256, 256), paint2);

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i].point, points[i + 1].point, paint);
      }
    }
    final picture = recorder.endRecording();
    final img = await picture.toImage(256, 256);

    final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);
    listBytes = Uint8List.view(pngBytes.buffer);

    //File image = await writeBytes(listBytes);
    String base64 = base64Encode(listBytes);
    //saveImageToGallery(listBytes);
    fetchResponse(base64);
  }

  void fetchResponse(var base64Image) async {
    var data = {"Image": base64Image};
    var url = Uri.parse("http://192.168.52.132:5000/predict");

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
      print(" *Error has Occured");
      return null;
    }
  }

  void displayResponseImage(String bytes) async {
    convertedBytes = base64Decode(bytes);
    setState(() {
      imageOutput = Container(
          width: 256,
          height: 256,
          child: Image.memory(convertedBytes, fit: BoxFit.contain));
    });
  }

  void loadImage(File file) {
    if (file != null) {
      img1 = Image.file(file);
    } else {
      setState(() {
        img1 = null;
      });
    }
  }

  Future<String> fileToBase64(File file) async {
    if (file != null) {
      List<int> bytes = await file.readAsBytes();
      return base64Encode(bytes);
    }
    return null;
  }

  void pickImage() async {
    File file = await FilePicker.getFile();
    loadImage(file);
    var base64String = await fileToBase64(file);
    fetchResponse(base64String);
  }

  void showImageSavedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Image Saved'),
          content: Text('Image Stored In Gallery.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
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
          title: Text('No Sketch Found'),
          content: Text('Draw A Sketch First.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Draw Face Sketch'),
          actions: [
            DropdownButton(
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              items: [
                DropdownMenuItem(
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.exit_to_app),
                        SizedBox(width: 8),
                        Text('Logout'),
                      ],
                    ),
                  ),
                  value: 'logout',
                )
              ],
              onChanged: (itemIdentifier) {
                if (itemIdentifier == 'logout') {
                  FirebaseAuth.instance.signOut();
                }
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
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
                    padding: EdgeInsets.only(bottom: 15),
                    child: Container(
                      width: 256,
                      height: 256,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 510,
                                spreadRadius: 1)
                          ]),
                      child: GestureDetector(
                        onPanDown: (details) {
                          this.setState(() {
                            points.add(DrawingArea(
                                point: details.localPosition,
                                areaPaint: Paint()
                                  ..strokeCap = StrokeCap.round
                                  ..isAntiAlias = true
                                  ..color = Colors.white
                                  ..strokeWidth = 1.0));
                          });
                        },
                        onPanUpdate: (details) {
                          this.setState(() {
                            points.add(DrawingArea(
                                point: details.localPosition,
                                areaPaint: Paint()
                                  ..strokeCap = StrokeCap.round
                                  ..isAntiAlias = true
                                  ..color = Colors.white
                                  ..strokeWidth = 2.0));
                          });
                        },
                        onPanEnd: (details) {
                          saveToImage(points);
                          this.setState(
                            () {
                              points.add(null);
                            },
                          );
                        },
                        child: SizedBox.expand(
                            child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                          child: CustomPaint(
                            painter: MyCustomPainter(points: points),
                          ),
                        )),
                      ),
                    )),
                Container(
                  width: MediaQuery.of(context).size.width * 0.62,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            this.setState(() {
                              points.clear();
                            });
                          }),
                      IconButton(
                          icon: Icon(
                            Icons.image,
                            color: Colors.black,
                          ),
                          onPressed: pickImage),
                      IconButton(
                          icon: Icon(
                            Icons.save,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              if (points.isNotEmpty) {
                                final result = ImageGallerySaver.saveImage(
                                    Uint8List.fromList(listBytes));
                                if (result != null) {
                                  showImageSavedDialog(context);
                                } else {
                                  showImageNotSavedDialog(context);
                                }
                              } else {
                                showImageNotSavedDialog(context);
                              }
                            });
                          })
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Container(
                    child: Center(
                      child: Container(
                        height: 256,
                        width: 256,
                        child: imageOutput,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: imageOutput != null,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.62,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              this.setState(() {
                                imageOutput = null;
                              });
                            }),
                        IconButton(
                            icon: Icon(
                              Icons.save,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                if (convertedBytes.isNotEmpty) {
                                  final result = ImageGallerySaver.saveImage(
                                      Uint8List.fromList(convertedBytes));
                                  if (result != null) {
                                    showImageSavedDialog(context);
                                  } else {
                                    showImageNotSavedDialog(context);
                                  }
                                } else {
                                  showImageNotSavedDialog(context);
                                }
                              });
                            })
                      ],
                    ),
                  ),
                )
              ],
            ))
          ],
        ));
  }
}
