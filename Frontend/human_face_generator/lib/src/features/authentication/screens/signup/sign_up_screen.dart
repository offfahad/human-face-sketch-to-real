import 'package:flutter/material.dart';
import 'package:human_face_generator/src/constants/sizes.dart';
import 'package:human_face_generator/src/features/authentication/screens/signup/sign_up_form_widget.dart';
import 'package:human_face_generator/src/features/authentication/screens/signup/signup_footer_widget.dart';
import 'package:human_face_generator/src/features/authentication/screens/signup/signup_header_widget.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              width: 450,
              padding: const EdgeInsets.all(tDefaultSize + 20),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // FormHeaderWidget(
                  //   image: tWelcomeScreenImage,
                  //   title: tSignUpTitle,
                  //   subTitle: tSignUpSubTitle,
                  //   imageHeight: 0.2,
                  //   heightBetween: 10,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  // ),
                  SignUpHeaderWidget(),
                  SignUpFormWidget(),
                  SignUpFooterWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}