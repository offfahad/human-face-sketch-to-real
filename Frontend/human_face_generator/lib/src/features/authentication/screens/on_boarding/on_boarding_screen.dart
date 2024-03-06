import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:human_face_generator/src/constants/colors.dart';
import 'package:human_face_generator/src/features/authentication/controllers/on_boarding_controller.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final obController = OnBoardingController();
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          LiquidSwipe(
            pages: obController.pages,
            enableSideReveal: true,
            liquidController: obController.controller,
            onPageChangeCallback: obController.onPageChangedCallback,
            slideIconWidget: const Icon(Icons.arrow_back_ios),
            waveType: WaveType.circularReveal,
          ),
          Positioned(
            bottom: 70.0,
            child: OutlinedButton(
              onPressed: () => obController.animateToNextSlide(),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, side: const BorderSide(color: Colors.black26),
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: const BoxDecoration(
                    color: tDarkColor, shape: BoxShape.circle),
                child: const Icon(Icons.arrow_forward_ios),
              ),
            ),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: () => obController.skip(),
              child: const Text("Skip", style: TextStyle(color: Colors.black, fontSize: 18)),
            ),
          ),
          Obx(
                () => Positioned(
              bottom: 20,
              child: AnimatedSmoothIndicator(
                count: 3,
                activeIndex: obController.currentPage.value,
                effect: const ExpandingDotsEffect(
                  activeDotColor: Color(0xff272727),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}