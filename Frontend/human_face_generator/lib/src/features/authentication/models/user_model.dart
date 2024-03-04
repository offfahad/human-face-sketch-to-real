

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  String fullName;
  String email;
  String phoneNo;
  String password;

  UserModel(
      {this.id,
      required this.fullName,
      required this.email,
      required this.phoneNo,
      required this.password});

  toJason() {
    return {
      "FullName": fullName,
      "Email": email,
      "Phone": phoneNo,
      "Password": password
    };
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
        id: document.id,
        fullName: data["FullName"],
        email: data["Email"],
        phoneNo: data["Phone"],
        password: data["Password"]);
  }
}
