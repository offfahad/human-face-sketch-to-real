import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:human_face_generator/src/constants/colors.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ResultImage extends StatelessWidget {
  final Uint8List imageBytes;
  const ResultImage({super.key, required this.imageBytes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(
              LineAwesomeIcons.angle_left_solid,
              color: tWhiteColor,
            ),
            onPressed: () => Get.back()),
        title: Text(
          "Real Image Generated",
          style: GoogleFonts.poppins(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: tWhiteColor,
          ),
        ),
        backgroundColor: tPrimaryColor,
      ),
      body: Center(
        child: Image.memory(imageBytes),
      ),
    );
  }
}
