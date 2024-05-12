import 'package:flutter/material.dart';
import 'package:human_face_generator/src/constants/colors.dart';

class DialogHelper {
  static void showImageSavedDialog(BuildContext context) {
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
              child: const Text(
                'OK',
                style: TextStyle(color: tPrimaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  static void showImageSavedDialogWb(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Image has been downloaded'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'OK',
                style: TextStyle(color: tPrimaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  static void showImageNotSupportedDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Invalid Sketch Image '),
          content: const Text(
              'Choose a sketch image which you saved from this application or follow guidelines.\n1) Sketch must be straight face sketch.\n2) Sketch must be drawn with white lines on black background.\n3) It should be in dimension of 256X256.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: tPrimaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  static void showImageNotSavedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Image Found'),
          content: const Text('Draw A Sketch First.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'OK',
                style: TextStyle(color: tPrimaryColor),
              ),
            ),
          ],
        );
      },
    );
  }
}
