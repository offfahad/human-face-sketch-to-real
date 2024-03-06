import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:human_face_generator/src/constants/sizes.dart';
import 'package:human_face_generator/src/constants/text_strings.dart';
import 'package:human_face_generator/src/features/authentication/controllers/opt_controller.dart';

class OTPScreen extends StatelessWidget {
  final String fetchedEmail; // Make it final to ensure it's set only once

  OTPScreen({Key? key, required this.fetchedEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var otpController = Get.put(OTPController());
    var otp;
    print(fetchedEmail);
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(tDefaultSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              tOtpTitle,
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold, fontSize: 80.0),
            ),
            Text(tOtpSubTitle.toUpperCase(),
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 40.0),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "$tOtpMessage",
                    style: TextStyle(
                      // Define your style for tOtpMessage here
                      fontWeight: FontWeight.normal,
                      // Add any other styles you need
                    ),
                  ),
                  TextSpan(
                    text: fetchedEmail,
                    style: const TextStyle(
                      // Make fetchedEmail bold
                      fontWeight: FontWeight.bold,
                      // Add any other styles you need
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            OtpTextField(
                mainAxisAlignment: MainAxisAlignment.center,
                numberOfFields: 6,
                fillColor: Colors.black.withOpacity(0.1),
                filled: true,
                cursorColor: Colors.black,
                onSubmit: (code) {
                  otp = code;
                  OTPController.instance.verifyOTP(otp);
                }),
            const SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    OTPController.instance.verifyOTP(otp);
                  },
                  child: const Text(tNext)),
            ),
          ],
        ),
      ),
    );
  }
}
