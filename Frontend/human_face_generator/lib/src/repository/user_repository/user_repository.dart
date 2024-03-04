import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:human_face_generator/src/features/authentication/models/user_model.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  createUser(UserModel user) async {
    await _db
        .collection("Users")
        .add(user.toJason())
        .whenComplete(() => Get.snackbar(
            "Success", "Your account has been created.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color.fromARGB(255, 38, 116, 40),
            colorText: Colors.white))
        .catchError((error, stackTrace) {
      Get.snackbar("Error", "Something went wrong. Try again.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      print(error.toString());
    });
  }

  Future<UserModel?> getUserDetails(String email) async {
    try {
      final snapshot =
          await _db.collection("Users").where("Email", isEqualTo: email).get();
      final userData =
          snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
      return userData;
    } catch (e) {
      print('Error fetching user details: $e');
      return null; // or handle the error as needed
    }
  }

  // Future<UserModel?> getUserDetails(String uid) async {
  //   try {
  //     final snapshot = await _db.collection("Users").doc(uid).get();
  //     if (snapshot.exists) {
  //       final userData = UserModel.fromSnapshot(snapshot);
  //       return userData;
  //     } else {
  //       print('User with UID $uid does not exist');
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Error fetching user details: $e');
  //     return null; // or handle the error as needed
  //   }
  // }

  Future<List<UserModel>> allUser() async {
    try {
      final snapshot = await _db.collection("Users").get();
      final userData =
          snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
      return userData;
    } catch (e) {
      print('Error fetching all users: $e');
      return []; // or handle the error as needed
    }
  }

  Future<void> updateUserRecord(UserModel user) {
    return _db
        .collection("Users")
        .doc(user.id!)
        .update(user.toJason())
        .whenComplete(() => Get.snackbar(
            "Success", "Your account has been updated.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color.fromARGB(255, 38, 116, 40),
            colorText: Colors.white))
        .catchError((error, stackTrace) {
      Get.snackbar("Error", "Something went wrong. Try again.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      print(error.toString());
    });
  }
}
