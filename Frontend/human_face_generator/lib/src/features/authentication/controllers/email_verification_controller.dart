// import 'dart:async';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'package:human_face_generator/src/repository/authentication_repository/authentication_repository.dart';

// class MailVerificationController extends GetxController {
//   late Timer _timer;

//   @override
//   void onInit() {
//     super.onInit();
//     sendVerificationEmail();
//     setTimeForAutoRedirect();
//   }

//   Future<void> sendVerificationEmail() async {
//     String? error =
//         await AuthenticationRepository.instance.sendEmailVerification();
//     if (error != null) {
//       Get.showSnackbar(GetSnackBar(
//         message: error.toString(),
//       ));
//     }
//   }

//   void setTimeForAutoRedirect() {
//     _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
//       FirebaseAuth.instance.currentUser?.reload();
//       final user = FirebaseAuth.instance.currentUser;
//       if (user!.emailVerified) {
//         timer.cancel();
//         AuthenticationRepository.instance.setInitialScreen(user);
//       }
//     });
//   }

//   void manullyCheckEmailVerificationStatus(){
//     FirebaseAuth.instance.currentUser?.reload();
//     final user = FirebaseAuth.instance.currentUser;
//     if(user!.emailVerified){
//       AuthenticationRepository.instance.setInitialScreen(user);
//     }
//   }
// }
