import 'package:get/get.dart';
import 'package:human_face_generator/src/features/authentication/models/user_model.dart';
import 'package:human_face_generator/src/repository/authentication_repository/authentication_repository.dart';
import 'package:human_face_generator/src/repository/user_repository/user_repository.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  final _authRepo = Get.put(AuthenticationRepository());
  final _userRepo = Get.put(UserRepository());

  bool isValidEmail(String email) {
    // Regular expression for email validation
    // You can customize this regex as per your requirements
    String emailPattern = r'^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$';
    RegExp regex = RegExp(emailPattern);

    // Check if the email matches the pattern and does not contain any uppercase letters
    return regex.hasMatch(email) && !email.contains(RegExp(r'[A-Z]'));
  }

  getUserData() {
    final email = _authRepo.firebaseUser.value!.email;
    print(email);
    if (email != null) {
      return _userRepo.getUserDetails(email);
    } else {
      Get.snackbar("Error", "Login to continue.");
    }
  }

  Future updateRecord(UserModel user) async {
    try {
      await _userRepo.updateUserRecord(user);
    } catch (e) {
      print('Error updating user record: $e');
      // You can throw a custom exception here or handle the error as per your requirement.
      throw Exception('Failed to update user record');
    }
  }
}
