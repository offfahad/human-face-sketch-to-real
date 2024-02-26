import 'package:flutter/material.dart';
import 'package:human_face_generator/src/utlis/theme/widgets_theme/elvevated_button_theme.dart';
import 'package:human_face_generator/src/utlis/theme/widgets_theme/outlined_button_theme.dart';
import 'package:human_face_generator/src/utlis/theme/widgets_theme/text_field_theme.dart';
import 'package:human_face_generator/src/utlis/theme/widgets_theme/text_theme.dart';

class TAppTheme {
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      textTheme: TTextTheme.lightTextTheme,
      outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
      elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
      inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    textTheme: TTextTheme.darkTextTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.darkOutlineddButtonTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme,
  );
}
