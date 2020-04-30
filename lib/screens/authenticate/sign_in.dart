import 'package:flutter/material.dart';
import 'package:racher/services/auth.dart';
import 'package:racher/shared/constants.dart';
import 'package:racher/shared/loading.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // text Field State
  String email = '';
  String password = '';
  
  // Error States
  String error = '';

  // Loading State
  bool loading = false;

  // Form SizedBox size
  double formSizedBoxHeight = 20.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
        body: Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 50.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 150,
                    child: Image(
                      image: AssetImage('assets/racher_logo.png')
                      ),
                  ),
                  SizedBox(height: 40),
                  TextFormField(
                    validator: (val) => val.isEmpty ? 'Enter Email' : null,
                    onChanged: (val) {
                      setState(() => email = val);
                    },
                    style: TextStyle(color: Colors.black87),
                    decoration: textInputDecoration.copyWith(hintText:'Enter your Email', labelText: 'Email'),
                  ),
                  SizedBox(height: formSizedBoxHeight),
                  TextFormField(
                    obscureText: true,
                    validator: (val) => val.length < 7 ? 'Enter a password more than 6 Characters long' : null,
                    onChanged: (val) {
                      setState(() => password = val);
                    },
                    style: TextStyle(color: Colors.black87),
                    decoration: textInputDecoration.copyWith(hintText:'Enter Password', labelText: 'Password'),
                  ),
                  SizedBox(height: formSizedBoxHeight),
                  SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      color: Colors.deepPurple[700],
                      child: loading ? Loading() : Text(
                        'Sign in',
                        style: TextStyle(color: Colors.white),
                      ),
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      onPressed: () async {
                        if (_formKey.currentState.validate()){
                          setState(() {loading = true;});
                          dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                          if (result == null) {
                            setState(() { 
                              error = 'Invalid credentials. Try again.';
                              loading = false;
                              });
                          }
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: OutlineButton(
                      color: Colors.white,
                      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.black87),
                      ),
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      onPressed: () {
                        widget.toggleView();
                      },
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14.0),
                  )
                ],
              ),
            )
            ),
        )
    );
  }
}