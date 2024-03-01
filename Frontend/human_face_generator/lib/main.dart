import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:human_face_generator/drawing_screen.dart';
import 'package:human_face_generator/firebase_options.dart';
import 'package:human_face_generator/src/features/authentication/screens/on_boarding/on_boarding_screen.dart';
import 'package:human_face_generator/src/repository/authentication_repository/authentication_repository.dart';
import 'package:human_face_generator/src/utlis/theme/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) => Get.put(AuthenticationRepository()));
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
        home: const OnBoardingScreen());
  }
}
