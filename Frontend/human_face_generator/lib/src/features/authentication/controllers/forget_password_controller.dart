import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:human_face_generator/src/repository/authentication_repository/authentication_repository.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();
  final isLoading = false.obs;

  bool isValidEmail(String email) {
    // Regular expression for email validation
    // You can customize this regex as per your requirements
    String emailPattern = r'^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$';
    RegExp regex = RegExp(emailPattern);

    // Check if the email matches the pattern and does not contain any uppercase letters
    return regex.hasMatch(email) && !email.contains(RegExp(r'[A-Z]'));
  }

  Future<void> resetPassword(String email) async {
    try {
      isLoading.value = true; // Set isLoading to true before login process

      String? error = await AuthenticationRepository.instance
          .forgetPasswordWithEmail(email);
      if (error == null) {
        Get.snackbar("Success",
            "Password reset email has been sent to your email address.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 10));
      }
      if (error != null) {
        Get.snackbar("Error", error.toString(),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 3));
      }
    } finally {
      isLoading.value =
          false; // Set isLoading back to false after login process
    }
  }
}
