import 'package:flutter/material.dart';
import 'screens/splashscreen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Face Generator',
      debugShowCheckedModeBanner: false,
      home: MySplash(),
    );
  }
}