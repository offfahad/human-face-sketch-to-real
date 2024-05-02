import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:human_face_generator/src/common_widgets/form/form_header_widget.dart';
import 'package:human_face_generator/src/constants/colors.dart';
import 'package:human_face_generator/src/constants/image_strings.dart';
import 'package:human_face_generator/src/constants/sizes.dart';
import 'package:human_face_generator/src/constants/text_strings.dart';
import 'package:human_face_generator/src/features/authentication/controllers/forget_password_controller.dart';
import 'package:human_face_generator/src/features/authentication/screens/forget_password/forget_password_otp/otp_screen.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class ForgetPasswordPhoneScreen extends StatefulWidget {
  const ForgetPasswordPhoneScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordPhoneScreen> createState() =>
      _ForgetPasswordPhoneScreenState();
}

class _ForgetPasswordPhoneScreenState extends State<ForgetPasswordPhoneScreen> {
  String userPhone = "";
  var Controller = Get.put(ForgetPasswordController());
  final _formKey = GlobalKey<FormState>();
  String? phoneNumber;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: tPrimaryColor,
            ),
            onPressed: () => Get.back(),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
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
                    subTitle: tForgetPhoneSubTitle2,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    heightBetween: 30.0,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: tFormHeight),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        IntlPhoneField(
                          flagsButtonPadding: const EdgeInsets.all(8),
                          dropdownIconPosition: IconPosition.trailing,
                          focusNode: FocusNode(),
                          //controller: controller.phoneNo,
                          keyboardType: TextInputType.phone,
                          //dropdownTextStyle: const TextStyle(fontSize: 16),
                          decoration: const InputDecoration(
                            label: Text(tPhoneNo),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                            ),
                          ),
                          initialCountryCode: 'PK',
                          onChanged: (phone) {
                            if (phone.completeNumber.isNotEmpty) {
                              phoneNumber = phone
                                  .completeNumber; // Get the complete phone number
                              // Update the controller with the complete phone number
                              //controller.phoneNo.text = phoneNumber;
                            }
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Phone number field cannot be empty! ';
                            }
                            return null;
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
                        if (_formKey.currentState!.validate()) {
                          Get.to(() => OTPScreen(fetchedEmail: phoneNumber ?? ''));
                          // setState(() {
                          //   Controller.resetPassword(
                          //     userEmail.trim().toString(),
                          //   );
                          // });
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
      ),
    );
  }
}
