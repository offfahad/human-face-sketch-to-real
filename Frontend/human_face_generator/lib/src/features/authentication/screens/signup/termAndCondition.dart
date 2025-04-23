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

class TermAndConditionScreen extends StatefulWidget {
  const TermAndConditionScreen({Key? key}) : super(key: key);

  @override
  State<TermAndConditionScreen> createState() => _TermAndConditionScreenState();
}

class _TermAndConditionScreenState extends State<TermAndConditionScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: tPrimaryColor,
            ),
            onPressed: () => Get.back(),
          ),
          elevation: 0,
        ),
        body: Center(
          child: Container(
            width: 450,
            padding: const EdgeInsets.all(tDefaultSize + 10),
            child: const Column(
              children: [
                Text(
                  'Terms and Conditions',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  textAlign: TextAlign.justify,
                  'By accepting the checkbox your are giving you provided information while signing up to us. Your provided information is secured and save and no other user of application can have the access of it.',
                  style: TextStyle(
                    fontSize: 20,
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
