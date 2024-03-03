import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:human_face_generator/src/repository/authentication_repository/authentication_repository.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();

  Future<void> login(String email, String password) async {
    String? error =
        await AuthenticationRepository.instance.loginWithEmailAndPassword(
      email,
      password,
    );

    if (error != null) {
      Get.showSnackbar(GetSnackBar(
        message: error.toString(),
        duration: const Duration(seconds: 3),
      ));
    }
  }

  Future<void> googleSignIn() async {
    try {
      await AuthenticationRepository.instance.signInWithGoogle();
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        message: e.toString(),
        duration: const Duration(seconds: 3),
      ));
    }
  }
}
