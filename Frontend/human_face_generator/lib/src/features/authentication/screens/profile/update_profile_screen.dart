import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:human_face_generator/src/constants/colors.dart';
import 'package:human_face_generator/src/constants/image_strings.dart';
import 'package:human_face_generator/src/constants/sizes.dart';
import 'package:human_face_generator/src/constants/text_strings.dart';
import 'package:human_face_generator/src/features/authentication/models/user_model.dart';
import 'package:human_face_generator/src/features/authentication/controllers/profile_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:uuid/uuid.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  bool _isPasswordVisible = false;
  final controller = Get.put(ProfileController());
  final _formKey = GlobalKey<FormState>();
  File? _pickedImage;
  Uint8List webImage = Uint8List(8);
  String? imageUrl;

  Future<void> _pickImage() async {
    if (!kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var selected = File(image.path);
        setState(() {
          _pickedImage = selected;
        });
      } else {
        print('No image has been picked');
      }
    } else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          webImage = f;
          _pickedImage = File('a');
        });
      } else {
        print('No image has been picked');
      }
    } else {
      print('Something went wrong');
    }
  }

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
                  final fetchedImage = userData.profileImage;
                  print(fetchedImage);
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
                              child: _pickedImage == null
                                  ? Image.network(
                                      fetchedImage,
                                      fit: BoxFit.fill,
                                    )
                                  : kIsWeb
                                      ? Image.memory(webImage,
                                          fit: BoxFit.cover)
                                      : Image.file(
                                          _pickedImage!,
                                          fit: BoxFit.cover,
                                        ),
                              // child: ClipRRect(
                              //   borderRadius: BorderRadius.circular(100),
                              //   child: Image.network(
                              //     fetchedImage, // Assuming fetchedImage is a valid URL
                              //     fit: BoxFit.cover,
                              //   ),
                              // ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: tPrimaryColor),
                              child: IconButton(
                                icon: const Icon(LineAwesomeIcons.camera,
                                    color: tWhiteColor),
                                onPressed: () {
                                  _pickImage();
                                },
                              ),
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
                              controller: email,
                              enabled: false,
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
                              controller: password,
                              enabled: false,
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
                                  final uuid = const Uuid().v4();
                                  if (_formKey.currentState!.validate()) {
                                    FocusScope.of(context).unfocus();
                                    if (_pickedImage == null) {
                                      final userData = UserModel(
                                        id: userId,
                                        fullName: fullname.text.trim(),
                                        email: email.text.trim(),
                                        phoneNo: phoneNo.text.trim(),
                                        password: password.text.trim(),
                                        profileImage: fetchedImage.toString(),
                                      );
                                      await controller.updateRecord(userData);
                                    } else {
                                      final ref = FirebaseStorage.instance
                                          .ref()
                                          .child('userProfileImage')
                                          .child('$uuid.jpg');
                                      if (kIsWeb) {
                                        await ref.putData(webImage);
                                      } else {
                                        await ref.putFile(_pickedImage!);
                                      }
                                      imageUrl = await ref.getDownloadURL();
                                      final userData = UserModel(
                                        id: userId,
                                        fullName: fullname.text.trim(),
                                        email: email.text.trim(),
                                        phoneNo: phoneNo.text.trim(),
                                        password: password.text.trim(),
                                        profileImage: imageUrl.toString(),
                                      );
                                      await controller.updateRecord(userData);
                                    }
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
