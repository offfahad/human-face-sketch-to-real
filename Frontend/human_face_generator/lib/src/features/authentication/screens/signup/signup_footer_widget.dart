import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:human_face_generator/src/constants/image_strings.dart';
import 'package:human_face_generator/src/constants/text_strings.dart';
import 'package:human_face_generator/src/features/authentication/controllers/login_controller.dart';
import 'package:human_face_generator/src/features/authentication/models/user_model.dart';
import 'package:human_face_generator/src/features/authentication/screens/login/login_screen.dart';
import 'package:human_face_generator/src/repository/user_repository/user_repository.dart';

class SignUpFooterWidget extends StatelessWidget {
  const SignUpFooterWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () async {
              if (kIsWeb) {
                await controller.googleSignInWeb();
                await addGmailToCollection();
              } else {
                controller.googleSignIn();
                await addGmailToCollection();
              }
            },
            icon: const Image(
              image: AssetImage(tGoogleLogoImage),
              width: 20.0,
            ),
            label: Text(tSignInWithGoogle.toUpperCase()),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextButton(
          onPressed: () => Get.to(() => const LoginScreen()),
          child: Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: ' '), // Add a space between the texts
                TextSpan(
                  text: tAlreadyHaveAnAccount,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const TextSpan(
                    text: ' '), // Add another space between the texts
                TextSpan(
                  text: tLogin.toUpperCase(),
                  style: const TextStyle(color: Colors.blue),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

final userRepo = Get.put(UserRepository());
Future<void> addGmailToCollection() async {
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    // Check if the user signed in with Google
    for (UserInfo userInfo in currentUser.providerData) {
      if (userInfo.providerId == 'google.com') {
        // User signed in with Google, reset other fields except for the Gmail account
        String email = currentUser.email ?? '';
        print(email);
        String fullName = '';
        String phoneNo = '';
        String password = '';
        String profileImage = tNetworkProfileImage;

        // Query Firestore to check if the user's email already exists in the collection
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .where('Email', isEqualTo: email)
            .get();

        if (querySnapshot.docs.isEmpty) {
          final user = UserModel(
              fullName: fullName,
              email: email,
              phoneNo: phoneNo,
              password: password,
              profileImage: profileImage);
          await userRepo.createUserOnCollection(user);
        } else {
          print('User already exists in collection');
          Get.snackbar("Success", "Welcome Back.",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: const Color.fromARGB(255, 38, 116, 40),
              colorText: Colors.white);
        }
      }
    }
  }
}
