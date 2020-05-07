import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racher/models/user.dart';
import 'package:racher/screens/authenticate/authenticate.dart';
import 'package:racher/screens/home/home.dart';

// Widget to return depending if the user is signed in or not
class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    
    // Return either Home or Authenticate
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}