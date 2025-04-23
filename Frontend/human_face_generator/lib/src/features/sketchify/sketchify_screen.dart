import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:human_face_generator/src/common_widgets/dialogs/dialog_helper.dart';
import 'package:human_face_generator/src/constants/colors.dart';
import 'package:human_face_generator/src/constants/server_url.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_image_gallery_saver/flutter_image_gallery_saver.dart';
import 'package:file_picker/file_picker.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:ui' as ui;

class SketchifyScreen extends StatefulWidget {
  const SketchifyScreen({super.key});

  @override
  State<SketchifyScreen> createState() => _SketchifyScreenState();
}

class _SketchifyScreenState extends State<SketchifyScreen> {
  File? selectedImage;
  String? resultImageBase64;
  Uint8List? convertedBytes;
  bool show = true;
  Widget? imageOutput = Container();
  File? file;
  PlatformFile? _imageFile;

  Future<void> pickAndCropImage() async {
    if (kIsWeb) {
      await _pickAndCropImageWeb();
    } else {
      await _pickAndCropImageMobile();
    }
  }

  Future<void> _pickAndCropImageMobile() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final cropped = await ImageCropper().cropImage(
      sourcePath: picked.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      maxWidth: 256,
      maxHeight: 256,
      compressFormat: ImageCompressFormat.png,
      uiSettings: [
        AndroidUiSettings(lockAspectRatio: false),
        IOSUiSettings(aspectRatioLockEnabled: false),
      ],
    );

    if (cropped != null) {
      _processCroppedImage(File(cropped.path));
    }
  }

  Future<void> _pickAndCropImageWeb() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result == null) return;
    _imageFile = result.files.first;

    // Decode the image to check dimensions
    final codec = await ui.instantiateImageCodec(_imageFile!.bytes!);
    final frame = await codec.getNextFrame();
    final image = frame.image;

    if (image.width != 256 || image.height != 256) {
      // If image is not 256x256, we need to crop it
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);

      // Calculate scale and offset to center the crop
      final scale = 256 / image.width > 256 / image.height
          ? 256 / image.width
          : 256 / image.height;

      final offset = Offset(
        (256 - image.width * scale) / 2,
        (256 - image.height * scale) / 2,
      );

      canvas.drawImageRect(
        image,
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
        Rect.fromLTWH(
            offset.dx, offset.dy, image.width * scale, image.height * scale),
        Paint(),
      );

      final picture = recorder.endRecording();
      final croppedImage = await picture.toImage(256, 256);
      final byteData =
          await croppedImage.toByteData(format: ui.ImageByteFormat.png);
      final croppedBytes = byteData!.buffer.asUint8List();

      _processCroppedImageWeb(croppedBytes);
    } else {
      // Image is already 256x256
      _processCroppedImageWeb(_imageFile!.bytes!);
    }
  }

  void _processCroppedImage(File imageFile) {
    setState(() {
      selectedImage = imageFile;
      resultImageBase64 = null;
      show = true;
    });
    sendToSketchifyApi(imageFile.path);
  }

  void _processCroppedImageWeb(Uint8List imageBytes) {
    setState(() {
      selectedImage = null; // No File object on web
      _imageFile = PlatformFile(
        name: 'cropped.png',
        size: imageBytes.length,
        bytes: imageBytes,
      );
      resultImageBase64 = null;
      show = true;
    });
    sendToSketchifyApiWeb(imageBytes);
  }

  Future<void> sendToSketchifyApi(String imagePath) async {
    final bytes = await File(imagePath).readAsBytes();
    await _sendImageToApi(bytes);
  }

  Future<void> sendToSketchifyApiWeb(Uint8List imageBytes) async {
    await _sendImageToApi(imageBytes);
  }

  Future<void> _sendImageToApi(Uint8List bytes) async {
    final base64Image = base64Encode(bytes);

    final response = await http.post(
      Uri.parse('${Constants.serverUrl}/sketchify'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"Image": base64Image}),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      setState(() {
        resultImageBase64 = json['Image'];
        convertedBytes = base64Decode(resultImageBase64!);
        show = false;
        imageOutput = RepaintBoundary(
          child: SizedBox(
            width: 256,
            height: 256,
            child: Image.memory(convertedBytes!, fit: BoxFit.contain),
          ),
        );
      });
    } else {
      print("Failed: ${response.body}");
      // Show error dialog
      DialogHelper.showErrorDialog(context, "Failed to process image");
    }
  }

  // Method for web platforms
  void downaloadRealImageWeb() async {
    if (convertedBytes != null) {
      String base64Image = base64Encode(Uint8List.fromList(convertedBytes!));
      String formattedDate =
          DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());
      final anchor = html.AnchorElement(
        href: 'data:application/octet-stream;base64,$base64Image',
      )
        ..setAttribute('download', 'sketch_image_$formattedDate.png')
        ..style.display = 'none';
      html.document.body!.children.add(anchor);
      anchor.click();
      html.document.body!.children.remove(anchor);
      DialogHelper.showImageSavedDialogWb(context);
    } else {
      DialogHelper.showImageNotSavedDialog(context);
    }
  }

  // Method for saving image on mobile
  void saveRealImageToGallery() async {
    if (convertedBytes != null) {
      await FlutterImageGallerySaver.saveImage(
          Uint8List.fromList(convertedBytes!));
      DialogHelper.showImageSavedDialog(context);
    } else {
      DialogHelper.showSketchNotSavedDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: tWhiteColor,
        ),
        centerTitle: true,
        title: Text(
          "Image To Sketch",
          style: GoogleFonts.poppins(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: tWhiteColor,
          ),
        ),
        backgroundColor: tPrimaryColor,
      ),
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
                      width: 257,
                      height: 257,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(0),
                        ),
                        color: Colors.white,
                        border: Border.all(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          width: 1,
                        ),
                      ),
                      child: kIsWeb
                          ? (_imageFile != null
                              ? Image.memory(_imageFile!.bytes!,
                                  fit: BoxFit.contain)
                              : const Center(
                                  child: Text(
                                    "Original Image",
                                    textAlign: TextAlign.center,
                                  ),
                                ))
                          : (selectedImage != null
                              ? Image.file(selectedImage!, fit: BoxFit.contain)
                              : const Center(
                                  child: Text(
                                    "Original Image",
                                    textAlign: TextAlign.center,
                                  ),
                                )),
                    ),
                    const SizedBox(height: 50),
                    Container(
                      width: 256,
                      height: 256,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.0),
                      ),
                      child: show
                          ? const Center(
                              child: Text(
                                "Sketch Image\nWill appear here",
                                textAlign: TextAlign.center,
                              ),
                            )
                          : imageOutput,
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
                        color: tPrimaryColor,
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
                                selectedImage = null;
                                _imageFile = null;
                                resultImageBase64 = null;
                                convertedBytes = null;
                                // show = true;
                              });
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 0),
                          IconButton(
                            onPressed: pickAndCropImage,
                            icon: const Icon(
                              Icons.upload,
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
                        color: tPrimaryColor,
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
                                show = true;
                              });
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 0),
                          IconButton(
                            onPressed: () {
                              if (kIsWeb) {
                                downaloadRealImageWeb();
                              } else {
                                saveRealImageToGallery();
                              }
                            },
                            icon: const Icon(
                              Icons.download,
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
