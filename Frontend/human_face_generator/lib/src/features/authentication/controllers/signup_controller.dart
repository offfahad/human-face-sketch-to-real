import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:human_face_generator/src/constants/image_strings.dart';
import 'package:human_face_generator/src/constants/colors.dart';
import 'package:human_face_generator/src/features/authentication/models/user_model.dart';
import 'package:human_face_generator/src/features/liveSketching/screens/drawing_layout_responsive.dart';
import 'package:human_face_generator/src/repository/authentication_repository/authentication_repository.dart';
import 'package:human_face_generator/src/repository/user_repository/user_repository.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();
  final email = TextEditingController();
  final password = TextEditingController();
  final fullName = TextEditingController();
  final phoneNo = TextEditingController();

  final userRepo = Get.put(UserRepository());

  bool isValidEmail(String email) {
    // Regular expression for email validation
    // You can customize this regex as per your requirements
    String emailPattern = r'^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$';
    RegExp regex = RegExp(emailPattern);

    // Check if the email matches the pattern and does not contain any uppercase letters
    return regex.hasMatch(email) && !email.contains(RegExp(r'[A-Z]'));
  }

  Future<String?> registerUser(String email, String password) async {
    String? error = await AuthenticationRepository.instance
        .createUserWithEmailAndPassword(email, password);
    return error;
  }

  Future<String?> phoneAuthentication(String phoneNo) async {
    String? error =
        await AuthenticationRepository.instance.phoneAuthentication(phoneNo);
    return error;
  }

  Future<bool> createUser(UserModel user) async {
    String? error = await registerUser(user.email, user.password);
    if (error != null) {
      Get.snackbar("Error", error.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3));
      return false;
    }

    await userRepo.createUserOnCollection(user);
    return true;
  }

  Future<void> createGmailUser(UserModel user) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // Check if the user signed in with Google
      for (UserInfo userInfo in currentUser.providerData) {
        if (userInfo.providerId == 'google.com') {
          // User signed in with Google, reset other fields except for the Gmail account
          user.fullName = '';
          user.phoneNo = '';
          user.password = '';
          user.profileImage = tNetworkProfileImage;
          // Store the Gmail account ID (email) in the user object
          user.email = currentUser.email ?? '';
        }
      }
    }
    await userRepo.createUserOnCollection(user);
  }
}
