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
          title: const Text('Image Not Supported'),
          content: const Text(
              'Please choose a sketch image which you saved from this application.'),
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
