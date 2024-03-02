import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:human_face_generator/src/features/authentication/models/user_model.dart';
import 'package:human_face_generator/src/features/authentication/screens/forget_password/forget_password_otp/otp_screen.dart';
import 'package:human_face_generator/src/repository/authentication_repository/authentication_repository.dart';
import 'package:human_face_generator/src/repository/user_repository/user_repository.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();
  final email = TextEditingController();
  final password = TextEditingController();
  final fullName = TextEditingController();
  final phoneNo = TextEditingController();

  final userRepo = Get.put(UserRepository());

 void registerUser(String email, String password) async {
    String? error = await AuthenticationRepository.instance.createUserWithEmailAndPassword(email, password);
    if(error != null) {
      Get.showSnackbar(GetSnackBar(message: error.toString(),));
    }
  }

  void phoneAuthentication(String phoneNo){
    AuthenticationRepository.instance.phoneAuthentication(phoneNo);
  }

  Future<void> createUser(UserModel user) async {
    await userRepo.createUser(user);
    phoneAuthentication(user.phoneNo);
    Get.to(()=> const OTPScreen());
  }
}