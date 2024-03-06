import 'package:flutter/material.dart';
import 'package:human_face_generator/src/constants/colors.dart';
import 'package:human_face_generator/src/constants/sizes.dart';

class TElevatedButtonTheme {
  TElevatedButtonTheme._();

  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      
      foregroundColor: tWhiteColor,
      backgroundColor: tPrimaryColor,
      side: const BorderSide(color: tPrimaryColor),
      padding: const EdgeInsets.symmetric(vertical: tButtonHeight),
    ),
  );

  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      foregroundColor: tSecondaryColor,
      backgroundColor: tWhiteColor,
      side: const BorderSide(color: tSecondaryColor),
      padding: const EdgeInsets.symmetric(vertical: tButtonHeight),
    ),
  );
}
