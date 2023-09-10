

import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {

  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;

  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  

  void _trySubmit(){
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if(isValid){
      _formKey.currentState.save();
      print(_userEmail);
      print(_userName);
      print(_userPassword);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    key: ValueKey('emai l'),
                    validator: (value){
                      if(value.isEmpty || !value.contains('@gmail.com')){
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'Email Address'),
                    onSaved: (value){
                      _userEmail = value;
                    },
                  ),
                  if(!_isLogin)
                  TextFormField(
                    key: ValueKey('username'),
                    validator: (value){
                      if(value.isEmpty || value.length<4){
                        return 'Please enter at least 4 characters';
                      }
                    },
                    decoration: InputDecoration(labelText: 'Username'),
                    onSaved: (value){
                      _userName = value;
                    },
                  ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value){
                      if(value.isEmpty || value.length<7){
                        return 'Password must be at least 7 characters long';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    onSaved: (value){
                      _userPassword = value;
                    },
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  RaisedButton(
                    child: Text(_isLogin ? 'Login' : 'Sign Up'),
                    onPressed: _trySubmit,
                  ),
                  FlatButton(
                    child: Text(_isLogin ? 'Create new account' : 'I already have an account'),
                    onPressed: (){
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    }
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
