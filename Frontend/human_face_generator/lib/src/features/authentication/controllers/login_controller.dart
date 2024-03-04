import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:human_face_generator/src/repository/authentication_repository/authentication_repository.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();
  final isLoading = false.obs;

  bool isValidEmail(String email) {
    // Regular expression for email validation
    // You can customize this regex as per your requirements
    String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regex = RegExp(emailPattern);
    return regex.hasMatch(email);
  }

  Future<void> login() async {
    try {
      isLoading.value = true; // Set isLoading to true before login process

      String? error =
          await AuthenticationRepository.instance.loginWithEmailAndPassword(
        email.text.trim(),
        password.text.trim(),
      );

      if (error != null) {
        Get.showSnackbar(GetSnackBar(
          message: error.toString(),
          duration: const Duration(seconds: 3),
        ));
      }
    } finally {
      isLoading.value =
          false; // Set isLoading back to false after login process
    }
  }

  Future<void> googleSignIn() async {
    try {
      isLoading.value = true;
      final userCredential =
          await AuthenticationRepository.instance.signInWithGoogle();

      if (userCredential != null) {
        // If sign-in is successful, show a success message
        Get.snackbar(
          "Success",
          "Sign In With Google Account Successfully.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 38, 116, 40),
          colorText: Colors.white,
        );
      } else {
        // If userCredential is null, something went wrong
        throw 'Sign-in failed. User credential is null.';
      }
    } catch (e) {
      // Handle exceptions and errors
      print('Error during Google sign-in: $e');
      Get.snackbar(
        "Error",
        "Something went wrong. Try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      // Regardless of success or failure, set isLoading to false
      isLoading.value = false;
    }
  }

  Future<void> googleSignInWeb() async {
    try {
      isLoading.value = true;
      await AuthenticationRepository.instance.signInWithGoogleWb();
      // If the sign-in process completes successfully, no further action is needed here
    } catch (e) {
      // Handle exceptions and errors
      print('Error during web Google sign-in: $e');
      isLoading.value = false;
      Get.showSnackbar(GetSnackBar(
        message: e.toString(),
        duration: const Duration(seconds: 3),
      ));
    } finally {
      // Ensure isLoading is always set to false regardless of success or failure
      isLoading.value = false;
    }
  }
}
