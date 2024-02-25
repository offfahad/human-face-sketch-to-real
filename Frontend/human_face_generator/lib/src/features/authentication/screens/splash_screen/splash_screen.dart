import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:human_face_generator/src/constants/colors.dart';
import 'package:human_face_generator/src/constants/image_strings.dart';
import 'package:human_face_generator/src/constants/sizes.dart';
import 'package:human_face_generator/src/constants/text_strings.dart';
import 'package:human_face_generator/src/features/authentication/controllers/splash_screen_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

  final splashController = Get.put(SplashScreenController());

  @override
  Widget build(BuildContext context) {
    SplashScreenController.find.startAnimation();

    return Scaffold(
      body: Stack(
        children: [
          Obx(
            () => AnimatedPositioned(
              duration: const Duration(milliseconds: 2000),
              top: 200,
              left: splashController.animate.value ? tDefaultSize : -80,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 2000),
                opacity: splashController.animate.value ? 1 : 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tAppName, style: Theme.of(context).textTheme.titleSmall),
                    Text(tAppTagLine, style: Theme.of(context).textTheme.displayMedium)
                  ],
                ),
              ),
            ),
          ),
          Obx(
            () => AnimatedPositioned(
              left: 20,
              duration: const Duration(milliseconds: 2400),
              bottom: splashController.animate.value ? 200 : 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 2000),
                opacity: splashController.animate.value ? 1 : 0,
                child: const Image(width: 350, height: 350, image: AssetImage(tSplashImage)),
              ),
            ),
          ),
          Obx(
            () => AnimatedPositioned(
              duration: const Duration(milliseconds: 2400),
              bottom: splashController.animate.value ? 150 : 0,
              left: 350,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 2000),
                opacity: splashController.animate.value ? 1 : 0,
                child: Container(
                  width: tSplashContainerSize,
                  height: tSplashContainerSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: tPrimaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}