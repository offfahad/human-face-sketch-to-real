import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:human_face_generator/drawing_screen.dart';
import 'package:human_face_generator/src/constants/sizes.dart';
import 'package:human_face_generator/src/constants/text_strings.dart';
import 'package:human_face_generator/src/features/authentication/controllers/login_controller.dart';
import 'package:human_face_generator/src/features/authentication/screens/forget_password/forget_password_options/forget_password_model_bottom_sheet.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final _formKey = GlobalKey<FormState>();

    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: tFormHeight - 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: controller.email,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person_outline_outlined),
                labelText: tEmail,
                hintText: tEmail,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              controller: controller.password,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.fingerprint),
                labelText: tPassword,
                hintText: tPassword,
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: null,
                  icon: Icon(Icons.remove_red_eye_sharp),
                ),
              ),
            ),
            const SizedBox(height: tFormHeight - 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () {
                    ForgetPasswordScreen.buildShowModalBottomSheet(context);
                  },
                  child: const Text(tForgetPassword)),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    LoginController.instance.login(controller.email.text.trim(),
                        controller.password.text.trim());
                  }
                },
                child: Text(tLogin.toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
