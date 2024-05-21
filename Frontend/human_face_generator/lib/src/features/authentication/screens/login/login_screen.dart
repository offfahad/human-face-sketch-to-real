import 'package:flutter/material.dart';
import 'package:human_face_generator/src/constants/sizes.dart';
import 'package:human_face_generator/src/features/authentication/screens/login/login_footer_widget.dart';
import 'package:human_face_generator/src/features/authentication/screens/login/login_form_widget.dart';
import 'package:human_face_generator/src/features/authentication/screens/login/login_header_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Get the size in LoginHeaderWidget()
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(tDefaultSize + 20),
              width: 450,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20,),
                  LoginHeaderWidget(),
                  LoginForm(),
                  LoginFooterWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
