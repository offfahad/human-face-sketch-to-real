import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:human_face_generator/src/common_widgets/form/form_header_widget.dart';
import 'package:human_face_generator/src/constants/colors.dart';
import 'package:human_face_generator/src/constants/image_strings.dart';
import 'package:human_face_generator/src/constants/sizes.dart';
import 'package:human_face_generator/src/constants/text_strings.dart';
import 'package:human_face_generator/src/features/authentication/controllers/forget_password_controller.dart';
import 'package:human_face_generator/src/features/authentication/screens/forget_password/forget_password_otp/otp_screen.dart';

class ForgetPasswordMailScreen extends StatefulWidget {
  const ForgetPasswordMailScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordMailScreen> createState() =>
      _ForgetPasswordMailScreenState();
}

class _ForgetPasswordMailScreenState extends State<ForgetPasswordMailScreen> {
  String userEmail = "";
  var Controller = Get.put(ForgetPasswordController());
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
        backgroundColor: tPrimaryColor,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 450,
            padding: const EdgeInsets.all(tDefaultSize + 10),
            child: Column(
              children: [
                const SizedBox(height: tDefaultSize * 4),
                FormHeaderWidget(
                  image: tForgetPasswordImage,
                  title: tForgetPassword.toUpperCase(),
                  subTitle: tForgetMailSubTitle2,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  heightBetween: 30.0,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: tFormHeight),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          label: Text(tEmail),
                          hintText: tEmail,
                          prefixIcon: Icon(Icons.mail_outline_rounded),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email field cannot be empty!';
                          }
                          if (!Controller.isValidEmail(value)) {
                            return 'Please enter a valid email address!';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            userEmail = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      print(userEmail);
                      if (_formKey.currentState!.validate()) {
                        //Get.to(() => OTPScreen(fetchedEmail: userEmail));
                        setState(() {
                          Controller.resetPassword(
                            userEmail.trim().toString(),
                          );
                        });
                      }
                    },
                    child: const Text("Send"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
