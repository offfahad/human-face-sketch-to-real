import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:human_face_generator/src/constants/image_strings.dart';
import 'package:human_face_generator/src/constants/text_strings.dart';
import 'package:human_face_generator/src/features/authentication/controllers/login_controller.dart';
import 'package:human_face_generator/src/features/authentication/screens/login/login_screen.dart';

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
            onPressed: () {
              if (kIsWeb) {
                controller.googleSignInWeb();
              } else {
                controller.googleSignIn();
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
          child: Text.rich(TextSpan(children: [
            TextSpan(
              text: tAlreadyHaveAnAccount,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            TextSpan(text: tLogin.toUpperCase())
          ])),
        )
      ],
    );
  }
}
