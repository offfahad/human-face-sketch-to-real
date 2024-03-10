import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:human_face_generator/src/constants/colors.dart';
import 'package:human_face_generator/src/constants/image_strings.dart';
import 'package:human_face_generator/src/constants/sizes.dart';
import 'package:human_face_generator/src/constants/text_strings.dart';
import 'package:human_face_generator/src/features/authentication/models/user_model.dart';
import 'package:human_face_generator/src/features/authentication/controllers/profile_controller.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  bool _isPasswordVisible = false;
  final controller = Get.put(ProfileController());
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: tPrimaryColor,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              LineAwesomeIcons.angle_left,
              color: tWhiteColor,
            )),
        title: Text(
          tEditProfile,
          style: GoogleFonts.poppins(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: tWhiteColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(tDefaultSize),
          child: FutureBuilder(
            future: controller.getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  UserModel userData = snapshot.data as UserModel;
                  final userId = userData.id!;
                  print(userId);
                  final email = TextEditingController(text: userData.email);
                  final password =
                      TextEditingController(text: userData.password);
                  final fullname =
                      TextEditingController(text: userData.fullName);
                  final phoneNo = TextEditingController(text: userData.phoneNo);

                  return Column(
                    children: [
                      // -- IMAGE with ICON
                      Stack(
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: const Image(
                                    image: AssetImage(tUserImage))),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: tPrimaryColor),
                              child: const Icon(LineAwesomeIcons.camera,
                                  color: tWhiteColor),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),

                      // -- Form Fields
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: fullname,
                              decoration: const InputDecoration(
                                label: Text(tFullName),
                                prefixIcon: Icon(LineAwesomeIcons.user),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Name field cannot be empty!';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: tFormHeight - 20),
                            TextFormField(
                              controller: email,
                              decoration: const InputDecoration(
                                label: Text(tEmail),
                                prefixIcon: Icon(LineAwesomeIcons.envelope_1),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email field cannot be empty!';
                                }
                                if (!controller.isValidEmail(value)) {
                                  return 'Please enter a valid email address!';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: tFormHeight - 20),
                            TextFormField(
                              controller: phoneNo,
                              decoration: const InputDecoration(
                                label: Text(tPhoneNo),
                                prefixIcon: Icon(LineAwesomeIcons.phone),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Phone number field cannot be empty!';
                                }

                                // Check if the value starts with a "+"
                                if (!value.startsWith('+')) {
                                  return 'Phone number must start with a "+" sign!';
                                }

                                // Remove non-digit characters from the value
                                String digitsOnly =
                                    value.replaceAll(RegExp(r'\D'), '');

                                // Check if the number of digits is exactly 12
                                if (digitsOnly.length != 12) {
                                  return 'Phone number must have exactly 12 digits after the "+" sign!';
                                }

                                // Return null if all checks pass
                                return null;
                              },
                            ),
                            const SizedBox(height: tFormHeight - 20),
                            TextFormField(
                              controller: password,
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
                                if (value == null || value.isEmpty) {
                                  return 'Password field cannot be empty!';
                                }
                                if (value.length < 7) {
                                  return 'Password must be at least 7 characters long!';
                                }
                                return null;
                              },
                              obscureText: !_isPasswordVisible,
                            ),
                            const SizedBox(height: tFormHeight),

                            // -- Form Submit Button
                            SizedBox(
                              width: 200,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    final userData = UserModel(
                                      id: userId,
                                      fullName: fullname.text.trim(),
                                      email: email.text.trim(),
                                      phoneNo: phoneNo.text.trim(),
                                      password: password.text.trim(),
                                    );
                                    await controller.updateRecord(userData);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: tPrimaryColor,
                                    side: BorderSide.none,
                                    shape: const StadiumBorder()),
                                child: const Text(tEditProfile,
                                    style: TextStyle(color: tWhiteColor)),
                              ),
                            ),
                            const SizedBox(height: tFormHeight),

                            // -- Created Date and Delete Button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text.rich(
                                  TextSpan(
                                    text: tJoined,
                                    style: TextStyle(fontSize: 12),
                                    children: [
                                      TextSpan(
                                          text: tJoinedAt,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12))
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.redAccent.withOpacity(0.1),
                                      elevation: 0,
                                      foregroundColor: Colors.red,
                                      shape: const StadiumBorder(),
                                      side: BorderSide.none),
                                  child: const Text(tDelete),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  return const Center(
                    child: Text("Too Slow Intnet Connection Try Again."),
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    color: tPrimaryColor,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
