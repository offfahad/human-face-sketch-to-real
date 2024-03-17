import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:human_face_generator/src/constants/colors.dart';
import 'package:human_face_generator/src/constants/image_strings.dart';
import 'package:human_face_generator/src/constants/sizes.dart';
import 'package:human_face_generator/src/constants/text_strings.dart';
import 'package:human_face_generator/src/features/authentication/controllers/signup_controller.dart';
import 'package:human_face_generator/src/features/authentication/models/user_model.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class SignUpFormWidget extends StatefulWidget {
  const SignUpFormWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpFormWidget> createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
  bool _isPasswordVisible = false;
  final controller = Get.put(SignUpController());
  final _formKey = GlobalKey<FormState>();
  bool _isSigningUp = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: tFormHeight - 20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              keyboardType: TextInputType.name,
              controller: controller.fullName,
              decoration: const InputDecoration(
                label: Text(tFullName),
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Name field cannot be empty!';
                }
                return null;
              },
            ),
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: controller.email,
              decoration: const InputDecoration(
                label: Text(tEmail),
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email field cannot be empty!';
                }
                String trimmedValue = value.trim();
                if (!controller.isValidEmail(trimmedValue)) {
                  return 'Please enter a valid email address!';
                }
                return null;
              },
            ),
            const SizedBox(height: tFormHeight - 20),
            // TextFormField(
            //   controller: controller.phoneNo,
            //   decoration: const InputDecoration(
            //     label: Text(tPhoneNo),
            //     prefixIcon: Icon(Icons.numbers),
            //   ),
            // ),
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
                  String phoneNumber =
                      phone.completeNumber; // Get the complete phone number

                  // Update the controller with the complete phone number
                  controller.phoneNo.text = phoneNumber;
                }
              },
              validator: (value) {
                if (value == null) {
                  return 'Phone number field cannot be empty! ';
                }
                return null;
              },
            ),

            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              controller: controller.password,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.fingerprint),
                labelText: tPassword,
                hintText: tPassword,
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: tPrimaryColor,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Password field cannot be empty!';
                }
                String trimmedValuePass = value.trim();
                if (trimmedValuePass.length < 7) {
                  return 'Password must be at least 7 characters long!';
                }
                return null;
              },
              obscureText: !_isPasswordVisible,
            ),
            const SizedBox(height: tFormHeight - 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    //   SignUpController.instance.registerUser(controller.email.text.trim(), controller.password.text.trim());
                    //SignUpController.instance
                    //    .phoneAuthentication(controller.phoneNo.text.trim());
                    //Get.to(() => const OTPScreen());
                    // }
                    setState(() {
                      _isSigningUp = true;
                    });
                    final user = UserModel(
                      fullName: controller.fullName.text.trim(),
                      email: controller.email.text.trim(),
                      phoneNo: controller.phoneNo.text.trim(),
                      password: controller.password.text.trim(),
                      profileImage: tNetworkProfileImage,
                    );
                    await SignUpController.instance.createUser(user);
                    setState(() {
                      _isSigningUp = false;
                    });
                  }
                },
                child: _isSigningUp ? const CircularProgressIndicator(color: Colors.white,) : Text(tSignup.toUpperCase()),
              ),
            ),
            const SizedBox(height: tFormHeight - 10),
            const Center(child: Text("OR")),
          ],
        ),
      ),
    );
  }
}
