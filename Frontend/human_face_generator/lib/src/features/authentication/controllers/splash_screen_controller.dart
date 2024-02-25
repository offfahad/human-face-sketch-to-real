import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:human_face_generator/drawing_screen.dart';

class SplashScreenController extends GetxController{
  static SplashScreenController get find => Get.find();


  RxBool animate = false.obs;


  Future startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    animate.value = true;
    await Future.delayed(const Duration(milliseconds: 7000));
    Get.to(const DrawingScreen());
  }
}