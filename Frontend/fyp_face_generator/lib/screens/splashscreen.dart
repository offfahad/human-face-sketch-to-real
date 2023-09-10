import 'package:flutter/material.dart';
import 'package:fyp_face_generator/screens/auth_screen.dart';
import 'package:splashscreen/splashscreen.dart';
import './home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MySplash extends StatefulWidget {
  @override
  State<MySplash> createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (ctx, userSnapshot) {
          if (userSnapshot.hasData) {
            return Home();
          }
          return AuthScreen();
        },
      ),
      title: const Text(
        'Face Generator App',
        style: TextStyle( 
            fontWeight: FontWeight.bold, fontSize: 35, color: Colors.white),
      ),
      gradientBackground: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(14, 35, 135, 1.0),
            Color.fromRGBO(24, 64, 87, 1.0),
            Color.fromRGBO(54, 53, 150, 1.0)
          ]),
      loaderColor: Colors.white,
      loadingText: Text(
        "from Fahad",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
    );
  }
}
