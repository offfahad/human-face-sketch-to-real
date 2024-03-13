import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:human_face_generator/src/constants/colors.dart';
import 'package:human_face_generator/src/constants/image_strings.dart';
import 'package:human_face_generator/src/constants/sizes.dart';
import 'package:human_face_generator/src/constants/text_strings.dart';
import 'package:human_face_generator/src/features/authentication/models/user_model.dart';
import 'package:human_face_generator/src/features/authentication/screens/profile/profile_menu_widget.dart';
import 'package:human_face_generator/src/features/authentication/screens/profile/update_profile_screen.dart';
import 'package:human_face_generator/src/features/authentication/controllers/profile_controller.dart';
import 'package:human_face_generator/src/features/liveSketching/screens/drawing_screen.dart';
import 'package:human_face_generator/src/features/withoutLive/models/drawing_point_without_live.dart';
import 'package:human_face_generator/src/features/withoutLive/screens/drawing_screen_without_live.dart';
import 'package:human_face_generator/src/repository/authentication_repository/authentication_repository.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: tPrimaryColor,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              LineAwesomeIcons.angle_left,
              color: tWhiteColor,
            )),
        title: Text(
          tProfile,
          style: GoogleFonts.poppins(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: tWhiteColor,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(tDefaultSize),
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                /// -- IMAGE
                Stack(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: const Image(image: AssetImage(tUserImage))),
                    ),
                    // Positioned(
                    //   bottom: 0,
                    //   right: 0,
                    //   child: Container(
                    //     width: 35,
                    //     height: 35,
                    //     decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(100),
                    //         color: tPrimaryColor),
                    //     child: const Icon(
                    //       LineAwesomeIcons.alternate_pencil,
                    //       color: tWhiteColor,
                    //       size: 20,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(height: 20),
                FutureBuilder(
                    future: controller.getUserData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          UserModel userData = snapshot.data as UserModel;
                          final email = userData.email;
                          final fullname = userData.fullName;
                          return Column(
                            children: [
                              Text(fullname,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium),
                              Text(email,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        } else {
                          return const Center(
                            child:
                                Text('Too Slow Internet Connection Try Again.'),
                          );
                        }
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: tPrimaryColor,
                          ),
                        );
                      }
                    }),

                const SizedBox(height: 20),

                /// -- BUTTON
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () => Get.to(() => const UpdateProfileScreen()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tPrimaryColor,
                      side: BorderSide.none,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      tEditProfile,
                      style: TextStyle(color: tWhiteColor),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Divider(),
                const SizedBox(height: 10),

                /// -- MENU
                // ProfileMenuWidget(
                //     title: "Settings",
                //     icon: LineAwesomeIcons.cog,
                //     onPress: () {}),
                // ProfileMenuWidget(
                //     title: "Billing Details",
                //     icon: LineAwesomeIcons.wallet,
                //     onPress: () {}),
                ProfileMenuWidget(
                    title: "Drawing Focus Mode",
                    icon: Icons.draw,
                    onPress: () {
                      Get.to(() => const DrawingScreenWithoutLive());
                    }),
                ProfileMenuWidget(
                    title: "Face Sketch To Real Mode",
                    icon: LineAwesomeIcons.pen_square,
                    onPress: () {
                      Get.to(() => const DrawingScreen());
                    }),

                const Divider(),
                const SizedBox(height: 10),
                ProfileMenuWidget(
                    title: "Information",
                    icon: LineAwesomeIcons.info,
                    onPress: () {}),
                ProfileMenuWidget(
                    title: "Logout",
                    icon: LineAwesomeIcons.alternate_sign_out,
                    textColor: Colors.red,
                    endIcon: false,
                    onPress: () async {
                      await _showLogoutDialog();
                    }),
                const Divider(),
                const SizedBox(height: 10),
                Text(
                  'Developed By @offfahad',
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showLogoutDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('LOGOUT'),
            content: const Text('Are you sure, you want to Logout?'),
            actions: [
              OutlinedButton(
                onPressed: () => Get.back(),
                child: const Text("No"),
              ),
              ElevatedButton(
                onPressed: () => AuthenticationRepository.instance.logout(),
                style: ElevatedButton.styleFrom(
                    backgroundColor: tPrimaryColor, side: BorderSide.none),
                child: const Text("Yes"),
              ),
            ],
          );
        });
  }
}
