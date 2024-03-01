import 'package:get/get.dart';
import 'package:human_face_generator/drawing_screen.dart';
import 'package:human_face_generator/src/repository/authentication_repository/authentication_repository.dart';

class OTPController extends GetxController {
  static OTPController get instance => Get.find();

  void verifyOTP(String otp) async {
    var isVerified = await AuthenticationRepository.instance.verifyOTP(otp);
    isVerified ? Get.offAll(const DrawingScreen()) : Get.back();
  }
}