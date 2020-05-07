import 'package:flutter/material.dart';
import 'package:racher/services/auth.dart';
import 'package:racher/shared/constants.dart';
import 'package:racher/shared/loading.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  // Service Used to Register user
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // Text Field States
  String firstName = '';
  String lastName = '';
  String email = '';
  String password = '';
  String confirmPassword = '';

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
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(50, 100, 50, 10),
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
                SizedBox(height: 20),
                TextFormField(
                  validator: (val) => val.isEmpty ? 'First Name cannot be empty' : null,
                  onChanged: (val) {
                    setState(() => firstName = val);
                  },
                  style: TextStyle(color: Colors.black87),
                  decoration: textInputDecoration.copyWith(hintText:'Enter First Name', labelText: 'First Name'),
                ),
                SizedBox(height: formSizedBoxHeight),
                TextFormField(
                  validator: (val) => val.isEmpty ? 'Last Name cannot be empty' : null,
                  onChanged: (val) {
                    setState(() => lastName = val);
                  },
                  style: TextStyle(color: Colors.black87),
                  decoration: textInputDecoration.copyWith(hintText:'Enter Last Name', labelText: 'Last Name'),
                ),
                SizedBox(height: formSizedBoxHeight),
                TextFormField(
                  validator: (val) => val.isEmpty ? 'Email cannot be empty' : null,
                  onChanged: (val) {
                    setState(() => email = val);
                  },
                  style: TextStyle(color: Colors.black87),
                  decoration: textInputDecoration.copyWith(hintText:'Enter Email', labelText: 'Email'),
                ),
                SizedBox(height: formSizedBoxHeight),
                TextFormField(
                  obscureText: true,
                  validator: (val) => val.length < 7 ? 'Enter a password more than 6 Characters long' : null,
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                  style: TextStyle(color: Colors.black87,),
                  decoration: textInputDecoration.copyWith(hintText:'Enter Password', labelText: 'Password'),
                ),
                SizedBox(height: formSizedBoxHeight),
                TextFormField(
                  obscureText: true,
                  validator: (val) => val != password ? 'Password is not the same.' : null,
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                  style: TextStyle(color: Colors.black87,),
                  decoration: textInputDecoration.copyWith(hintText:'Confirm your Password', labelText: 'Confirm Password'),
                ),
                SizedBox(height: formSizedBoxHeight),
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.deepPurple[700],
                    child: loading ? Loading() : Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    onPressed: () async {
                      if (_formKey.currentState.validate()){
                        setState(() {loading = true;});
                        dynamic result = await _auth.registerWithEmailAndPassword(email, password, firstName, lastName);
                        if (result == null) {
                          setState(() {
                            error = 'Please enter a valid email.';
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
                      'Sign in',
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
          )
    );
  }
}