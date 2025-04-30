import 'package:flutter/material.dart';
import 'package:human_face_generator/src/constants/colors.dart';

class DialogHelper {
  static void _showCustomDialog({
    required BuildContext context,
    required String title,
    required String content,
    IconData? icon,
    Color? iconColor,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          actionsPadding: const EdgeInsets.only(right: 16, bottom: 12),
          title: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: iconColor ?? tPrimaryColor),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: iconColor ?? tPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            content,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'OK',
                style: TextStyle(fontSize: 16, color: tPrimaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  // Image Saved (Sketch)
  static void showImageSavedDialog(BuildContext context) {
    _showCustomDialog(
      context: context,
      title: 'Image Saved',
      content: 'Image stored in gallery.',
      icon: Icons.check_circle,
      iconColor: tPrimaryColor,
    );
  }

  // Image Saved (Real -> Sketch)
  static void showImageSavedDialogWb(BuildContext context) {
    _showCustomDialog(
      context: context,
      title: 'Success',
      content: 'Image has been downloaded.',
      icon: Icons.cloud_download,
      iconColor: tPrimaryColor,
    );
  }

  // Invalid Sketch Format
  static void showImageNotSupportedDialog(BuildContext context) {
    _showCustomDialog(
      context: context,
      title: 'Invalid Sketch Image',
      content:
          'Choose a sketch image saved from this application or follow guidelines:\n\n'
          '1) Straight face sketch.\n'
          '2) White lines on black background.\n'
          '3) 256x256 resolution.',
      icon: Icons.warning_amber_rounded,
      iconColor: Colors.orange,
    );
  }

  // No Sketch Drawn
  static void showImageNotSavedDialog(BuildContext context) {
    _showCustomDialog(
      context: context,
      title: 'No Image Found',
      content: 'Draw a sketch first.',
      icon: Icons.image_not_supported,
      iconColor: Colors.red,
    );
  }

  static void showSketchNotSavedDialog(BuildContext context) {
    _showCustomDialog(
      context: context,
      title: 'No Image Found',
      content: 'Upload a real image first to see the sketch.',
      icon: Icons.image_not_supported,
      iconColor: Colors.red,
    );
  }

  // General Error
  static void showErrorDialog(BuildContext context, String message) {
    _showCustomDialog(
      context: context,
      title: 'Error',
      content: message,
      icon: Icons.error_outline,
      iconColor: Colors.red,
    );
  }

  // New: Real Image to Sketch – Processing Error
  static void showSketchifyErrorDialog(BuildContext context) {
    _showCustomDialog(
      context: context,
      title: 'Sketchify Failed',
      content:
          'Failed to process the real image into a sketch. Try again later.',
      icon: Icons.error_outline,
      iconColor: Colors.red,
    );
  }
}
