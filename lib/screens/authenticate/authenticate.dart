import 'package:flutter/material.dart';
import 'package:racher/screens/authenticate/register.dart';
import 'package:racher/screens/authenticate/sign_in.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;

// Function to toggle between Sign in & Register
  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn){
      return SignIn(toggleView: toggleView);  
    } else {
      return Register(toggleView: toggleView);
    }
  }
}