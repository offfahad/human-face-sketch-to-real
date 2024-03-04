import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:human_face_generator/drawing_screen.dart';
import 'package:human_face_generator/src/features/authentication/screens/on_boarding/on_boarding_screen.dart';
import 'package:human_face_generator/src/repository/authentication_repository/exceptions/t_exceptions.dart';

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
      final ex = TException.fromCode(e.code);
      print('Firebase Auth Exception - ${ex.message}');
      return ex.message;
    } catch (_) {
      const ex = TException();
      print('Exception - ${ex.message}');
      return ex.message;
    }
    return null;
  }

  Future<String?> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on PlatformException catch (e) {
      final ex = TException.fromCode(e.code);
      return ex.message;
    } catch (_) {
      const ex = TException();
      return ex.message;
    }
    return null;
  }

  Future<String?> phoneAuthentication(String phoneNo) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNo,
      verificationCompleted: (credential) async {
        await _auth.signInWithCredential(credential);
      },
      codeSent: (verificationId, resendToken) {
        this.verificationId.value = verificationId;
      },
      codeAutoRetrievalTimeout: (verificationId) {
        this.verificationId.value = verificationId;
      },
      verificationFailed: (e) {
        if (e.code == 'invalid-phone-number') {
          Get.snackbar('Error', 'The provided number is not valid!');
        } else {
          Get.snackbar('Error', 'Something went wrong. Try Again');
        }
      },
    );
    return null;
  }

  Future<bool> verifyOTP(String otp) async {
    try {
      var credential = await _auth.signInWithCredential(
        PhoneAuthProvider.credential(
          verificationId: verificationId.value,
          smsCode: otp,
        ),
      );

      return credential.user != null ? true : false;
    } catch (e) {
      // Handle the exception here
      print('Error verifying OTP: $e');
      return false; // Or you can throw the exception again to propagate it
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      final ex = TException.fromCode(e.code);
      print('Google Auth Exception - ${ex.message}');
      throw ex.message;
      
    } catch (_) {
      const ex = TException();
      print('google Auth Exception - ${ex.message}');
      throw ex.message;
    }
  }

  Future<UserCredential> signInWithGoogleWb() async {
  // Create a new provider
  GoogleAuthProvider googleProvider = GoogleAuthProvider();

  googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
  googleProvider.setCustomParameters({
    'login_hint': 'user@example.com'
  });

  // Once signed in, return the UserCredential
  return await _auth.signInWithPopup(googleProvider);

  // Or use signInWithRedirect
  // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
}


  Future<void> logout() async => await _auth.signOut();

  // Future<void> sendEmailVerification() async {
  //   try {
  //     _auth.currentUser?.sendEmailVerification();
  //   } on FirebaseAuthException catch (e) {
  //     final ex = TException.fromCode(e.code);
  //     throw ex.message;
  //   } catch (_) {
  //     const ex = TException();
  //     throw ex.message;
  //   }
  // }
}
