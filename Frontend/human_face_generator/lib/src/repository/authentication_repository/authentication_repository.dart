import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:human_face_generator/src/features/authentication/screens/on_boarding/on_boarding_screen.dart';
import 'package:human_face_generator/src/features/liveSketching/screens/drawing_layout_responsive.dart';
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
        : Get.offAll(() => const DrawingResponsiveLayout());
  }

  //FUNC
  Future<String?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      firebaseUser.value != null
          ? Get.offAll(() => const DrawingResponsiveLayout())
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

  Future<String?> forgetPasswordWithEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseException catch (error) {
      return error.message.toString();
    } catch (e) {
      return e.toString();
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

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Initialize GoogleSignIn
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // Sign out any previous user
      await googleSignIn.signOut();

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        // Obtain the auth details from the request
        final GoogleSignInAuthentication? googleAuth =
            await googleUser.authentication;

        if (googleAuth != null) {
          // Create a new credential
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          // Once signed in, return the UserCredential
          return await _auth.signInWithCredential(credential);
        } else {
          // Handle the case where authentication details are null
          print('Authentication details are null.');
          return null;
        }
      } else {
        // Handle the case where the user didn't select any account
        print('User did not select any account.');
        return null;
      }
    } on FirebaseAuthException catch (e) {
      final ex = TException.fromCode(e.code);
      print('Google Auth Exception - ${ex.message}');
      throw ex.message;
    } catch (e) {
      const ex = TException();
      print('Google Auth Exception - ${ex.message}');
      throw ex.message;
    }
  }

  Future<UserCredential?> signInWithGoogleWb() async {
    try {
      // Create a new provider
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      googleProvider
          .addScope('https://www.googleapis.com/auth/contacts.readonly');
      googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

      // Once signed in, return the UserCredential
      return await _auth.signInWithPopup(googleProvider);
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }

  Future<void> logout() async {
    // Check if the current user is signed in with Google
    if (FirebaseAuth.instance.currentUser?.providerData
            .any((info) => info.providerId == 'google.com') ??
        false) {
      try {
        await FirebaseAuth.instance.signOut();
        await GoogleSignIn().signOut(); // Sign out from Google
      } catch (e) {
        print('Error signing out: $e');
      }
    } else {
      // Handle sign-out for other providers (if any)
      await FirebaseAuth.instance.signOut();
    }
  }

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

void checkUserSignInMethod() {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    // Iterate through the user's provider data to check the sign-in method
    for (UserInfo userInfo in user.providerData) {
      if (userInfo.providerId == 'google.com') {
        print('User is signed in with Google account');
      } else if (userInfo.providerId == 'password') {
        print('User is signed in with email and password');
      }
      // Add conditions for other sign-in methods if needed
    }
  } else {
    print('No user is currently signed in');
  }
}
