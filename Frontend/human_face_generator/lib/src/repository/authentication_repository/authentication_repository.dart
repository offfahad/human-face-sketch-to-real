import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:human_face_generator/drawing_screen.dart';
import 'package:human_face_generator/src/features/authentication/screens/on_boarding/on_boarding_screen.dart';
import 'package:human_face_generator/src/repository/authentication_repository/exceptions/signin_email_password_exception.dart';
import 'package:human_face_generator/src/repository/authentication_repository/exceptions/signup_email_password_exception.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  //Variables
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;
  var verificationId = ''.obs;

  //Will be load when app launches this func will be called and set the firebaseUser state
  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  /// If we are setting initial screen from here
  /// then in the main.dart => App() add CircularProgressIndicator()
  _setInitialScreen(User? user) {
    user == null
        ? Get.offAll(() => const OnBoardingScreen())
        : Get.offAll(() => const DrawingScreen());
  }

  //FUNC
  Future<String?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      firebaseUser.value != null
          ? Get.offAll(() => const DrawingScreen())
          : Get.to(() => const OnBoardingScreen());
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      return ex.message;
      print('Firebase Auth Exception - ${ex.message}');
    } catch (_) {
      const ex = SignUpWithEmailAndPasswordFailure();
      return ex.message;
      print('Exception - ${ex.message}');
    }
    return null;
  }

  Future<String?> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      final ex = LogInWithEmailAndPasswordFailure.fromCode(e.code);
      return ex.message;
    } catch (_) {
      const ex = LogInWithEmailAndPasswordFailure();
      return ex.message;
    }
    return null;
  }

  Future<void> phoneAuthentication(String phoneNo) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNo,
      verificationCompleted: (credential) async {
        await _auth.signInWithCredential(credential);
      },
      codeSent: (verificationId, resendToken){
        this.verificationId.value = verificationId;
      },
      codeAutoRetrievalTimeout: (verificationId){
        this.verificationId.value = verificationId;
      },
      verificationFailed: (e){
        if(e.code == 'invalid-phone-number'){
          Get.snackbar('Error', 'The provided number is not valid!');
        }else{
          Get.snackbar('Error', 'Something went wrong. Try Again');
        }
      },
    );
  }

  Future<bool> verifyOTP(String otp) async{
    var credential = await _auth.signInWithCredential(PhoneAuthProvider.credential(verificationId: this.verificationId.value, smsCode: otp));
    return credential.user != null ? true : false;
  }

  Future<void> logout() async => await _auth.signOut();
}
