import 'package:flutter/material.dart';
import 'package:human_face_generator/src/utlis/theme/widgets_theme/text_theme.dart';

class TAppTheme {
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
      primarySwatch: Colors.yellow,
      brightness: Brightness.light,
      textTheme: TTextTheme.lightTextTheme,
      appBarTheme: AppBarTheme(),
      elevatedButtonTheme:
          ElevatedButtonThemeData(style: ElevatedButton.styleFrom()));
  static ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.yellow,
    brightness: Brightness.dark,
    textTheme: TTextTheme.darkTextTheme,
    appBarTheme: AppBarTheme(),
    floatingActionButtonTheme: FloatingActionButtonThemeData(),
    elevatedButtonTheme:
        ElevatedButtonThemeData(style: ElevatedButton.styleFrom()),
  );
}
