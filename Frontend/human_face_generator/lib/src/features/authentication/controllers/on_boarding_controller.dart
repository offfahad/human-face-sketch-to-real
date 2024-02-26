import 'package:get/get.dart';
import 'package:human_face_generator/src/constants/colors.dart';
import 'package:human_face_generator/src/constants/image_strings.dart';
import 'package:human_face_generator/src/constants/text_strings.dart';
import 'package:human_face_generator/src/features/authentication/models/model_on_boarding.dart';
import 'package:human_face_generator/src/features/authentication/screens/on_boarding/on_boarding_page_widget.dart';
import 'package:human_face_generator/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:liquid_swipe/PageHelpers/LiquidController.dart';


class OnBoardingController extends GetxController{

  final controller = LiquidController();
  RxInt currentPage = 0.obs;

  final pages = [
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: tOnBoardingImage1,
        title: tOnBoardingText1,
        subTitle: tOnBoardingSubText1,
        counterText: tOnBoardingCount1,
        bgColor: tOnBoardingPage1Color,
        
      ),
    ),
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: tOnBoardingImage2,
        title: tOnBoardingText2,
        subTitle: tOnBoardingSubText2,
        counterText: tOnBoardingCount2,
        bgColor: tOnBoardingPage2Color,
      ),
    ),
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: tOnBoardingImage3,
        title: tOnBoardingText3,
        subTitle: tOnBoardingSubText3,
        counterText: tOnBoardingCount3,
        bgColor: tOnBoardingPage3Color,
      ),
    ),
  ];


  void skip() {
    // Navigate to welcome screen
    Get.to(const WelcomeScreen());
  }

  animateToNextSlide() {
    int nextPage = controller.currentPage + 1;
    controller.animateToPage(page: nextPage);
  }
  onPageChangedCallback(int activePageIndex) => currentPage.value = activePageIndex;
}