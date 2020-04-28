import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racher/models/user.dart';
import 'package:racher/services/auth.dart';
import 'package:racher/services/database.dart';
import 'package:racher/shared/loading.dart';
import 'package:racher/shared/constants.dart';

class ProfilePage extends StatefulWidget {


  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  // text Field State
  String firstName = '';
  String lastName = '';

  // Error and Loading
  String error = '';
  bool loading = false;

  // edit toggle
  bool showEdit = false;

  editToggle(){
    setState(() {
      showEdit = !showEdit;
    });
  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData){

          UserData userData = snapshot.data;
          
          return new Scaffold(
            resizeToAvoidBottomInset : false,
            body: Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 0, 30),
                    child: Align(
                      alignment: Alignment.topLeft,
                        child: CircleAvatar(
                          radius: 50,
                        backgroundColor: Colors.deepPurple[700],
                        child: Text(
                          userData.firstName.substring(0, 1).toUpperCase() + userData.lastName.substring(0, 1).toUpperCase(),
                          style: TextStyle(fontSize: 40),
                          ),
                      ),
                    ),
                  ),
                  new Expanded(child: showEdit ? onEdit(userData) : beforeEdit(userData)),
                ],
              ),
            ),
          );
        } else {
          return LoadingFull();
        }
      },
    );
  }

  Widget signOutButton () {
    return SizedBox(
      width: double.infinity,
      child: RaisedButton.icon(
        color: Colors.redAccent[400],
        onPressed: () async {
          await _auth.signOut();
        }, 
        icon: Icon(
          Icons.exit_to_app,
          color: Colors.white,
        ), 
        label: Text(
          "Sign Out",
          style: TextStyle(color: Colors.white)),
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
        ),
    );
  }
  Widget beforeEdit(UserData userData) {
    return Column(
      children: <Widget>[
        SizedBox(
            width: double.infinity,
            child: Text(
              userData.firstName, 
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold
              ),
              )
            ),
          SizedBox(
            width: double.infinity,
            child: Text(
              userData.lastName, 
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.black26
              ),
              )
            ),
          Expanded(
            child: Container(),
          ),
          SizedBox(
            width: double.infinity,
            child: RaisedButton.icon(
              color: Colors.black26,
              onPressed: () {
                editToggle();
              }, 
              icon: Icon(
                Icons.edit,
                color: Colors.white,
              ), 
              label: Text(
                "Edit Profile",
                style: TextStyle(color: Colors.white)),
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
              ),
          ),
          signOutButton()
      ],
    );
  }
  Widget onEdit(UserData userData) {
    final AuthService _auth = AuthService();
    return Form(
        key: _formKey,
        child: Column(
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            child: TextFormField(
                initialValue: userData.firstName,
                validator: (val) => val.length < 2 ? 'Name cannot be less than 2 Characters' : null,
                onChanged: (val) {
                  setState(() => firstName = val);
                },
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 50,
                  fontWeight: FontWeight.bold
                  ),
                decoration: largeTextInputDecoration.copyWith(hintText:'First Name'),
              ),
            ),
          SizedBox(
            width: double.infinity,
            child: TextFormField(
                initialValue: userData.lastName,
                validator: (val) => val.length < 2 ? 'Name cannot be less than 2 Characters' : null,
                onChanged: (val) {
                  setState(() => lastName = val);
                },
                style: TextStyle(
                  color: Colors.black26,
                  fontSize: 50,
                  fontWeight: FontWeight.bold
                  ),
                decoration: largeTextInputDecoration.copyWith(hintText:'Last Name'),
              ),
            ),
          SizedBox(height: 12.0),
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                ),
          Expanded(
            child: Container(),
          ),
          Row(
            children: <Widget>[
             MaterialButton(
              minWidth: 0,
              onPressed: () {
                editToggle();
              },
              color: Colors.redAccent[400],
              textColor: Colors.white,
              child: Icon(
                Icons.close,
                size: 20,
              ),
              padding: EdgeInsets.all(10),
              shape: CircleBorder(),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: RaisedButton.icon(
                  color: Colors.deepPurple[700],
                  onPressed: () async {
                    if (_formKey.currentState.validate()){
                        setState(() {loading = true;});
                        if(lastName == ''){
                          setState(() {
                            lastName = userData.lastName;
                          });
                        } else if (firstName == ''){
                          setState(() {
                            firstName = userData.firstName;
                          });
                        }
                        dynamic result = await DatabaseService(uid: userData.uid).updateUserData(firstName, lastName, 'empty', false);
                        if (result != null) {
                          setState(() { 
                            error = 'Could not update.';
                            loading = false;
                            });
                        } else {
                          setState(() { 
                            error = '';
                            loading = false;
                            });
                          editToggle();
                          
                        }
                      }
                  }, 
                  icon: Icon(
                    Icons.check,
                    color: Colors.white,
                  ), 
                  label: loading ? Loading() : Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                  ),
              ),
            ]
          ),
          signOutButton()
        ],
      ),
    );
  }
}
