import 'package:flutter/material.dart';
import 'package:fyp_face_generator/widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
    void _submitAuthForm(
    String email,
    String password, 
    String username, 
    bool isLogin
    ){
      
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm)
    );
  }
}
