import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:human_face_generator/drawing_screen.dart';
import 'package:human_face_generator/firebase_options.dart';
import 'package:human_face_generator/src/utlis/theme/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: TAppTheme.lightTheme,
      //darkTheme: TAppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const DrawingScreen()
    );
  }
}

