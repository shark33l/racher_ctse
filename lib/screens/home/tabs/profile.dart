import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:racher/models/user.dart';
import 'package:racher/services/auth.dart';
import 'package:racher/services/database.dart';
import 'package:racher/services/uploadFirestore.dart';
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

  File displayPicture;

// Open Gallery and select image
  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      displayPicture = tempImage;
    });
  }

// Toggle between Edit and profile
  editToggle() {
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
        if (snapshot.hasData) {
          UserData userData = snapshot.data;

          return new Scaffold(
            resizeToAvoidBottomInset: false,
            resizeToAvoidBottomPadding: false,
            body: Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  new Expanded(
                      child:
                          showEdit ? onEdit(userData) : beforeEdit(userData)),
                ],
              ),
            ),
            bottomNavigationBar: Container(
              margin: EdgeInsets.all(0),
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              height: 110,
              child: Column(children: <Widget>[
                showEdit ? onEditButtons(userData) : beforeEditButton(),
                signOutButton()
              ]),
            ),
          );
        } else {
          return LoadingFull();
        }
      },
    );
  }

// Sign out button
  Widget signOutButton() {
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
        label: Text("Sign Out", style: TextStyle(color: Colors.white)),
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
      ),
    );
  }

// Screen to be visble before edit.
  Widget beforeEdit(UserData userData) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 0, 30),
            child: Align(
              alignment: Alignment.topLeft,
              child: ClipOval(
                child: getAvatar(userData),
              ),
            ),
          ),
          SizedBox(
              width: double.infinity,
              child: Text(
                userData.firstName,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              )),
          SizedBox(
              width: double.infinity,
              child: Text(
                userData.lastName,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.black26),
              )),
        ],
      ),
    );
  }

// Buttons to be visible before edit
  Widget beforeEditButton() {
    return SizedBox(
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
        label: Text("Edit Profile", style: TextStyle(color: Colors.white)),
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
      ),
    );
  }

// Edittable screen to be visible on Edit
  Widget onEdit(UserData userData) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 0, 30),
              child: Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () {
                    getImage();
                  },
                  child: ClipOval(
                      child: Stack(children: <Widget>[
                    getAvatarOnEdit(userData),
                    Positioned(
                      bottom: 0,
                      child: Container(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 30),
                          width: 100,
                          height: 30,
                          color: Colors.black38,
                          child: Center(
                            child: Icon(Icons.camera_alt,
                                color: Colors.white, size: 20),
                          )),
                    )
                  ])),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: TextFormField(
                initialValue: userData.firstName,
                validator: (val) => val.length < 2
                    ? 'Name cannot be less than 2 Characters'
                    : null,
                onChanged: (val) {
                  setState(() => firstName = val);
                },
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 50,
                    fontWeight: FontWeight.bold),
                decoration:
                    largeTextInputDecoration.copyWith(hintText: 'First Name'),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: TextFormField(
                initialValue: userData.lastName,
                validator: (val) => val.length < 2
                    ? 'Name cannot be less than 2 Characters'
                    : null,
                onChanged: (val) {
                  setState(() => lastName = val);
                },
                style: TextStyle(
                    color: Colors.black26,
                    fontSize: 50,
                    fontWeight: FontWeight.bold),
                decoration:
                    largeTextInputDecoration.copyWith(hintText: 'Last Name'),
              ),
            ),
            SizedBox(height: 12.0),
            Text(
              error,
              style: TextStyle(color: Colors.red, fontSize: 14.0),
            ),
          ],
        ),
      ),
    );
  }

// Buttons to be visible on edit
  Widget onEditButtons(UserData userData) {
    return Row(children: <Widget>[
      MaterialButton(
        minWidth: 0,
        onPressed: () {
          setState(() {
            displayPicture = null;
          });
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
      SizedBox(
        width: 10,
      ),
      Expanded(
        child: RaisedButton.icon(
          color: Colors.deepPurple[700],
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              setState(() {
                loading = true;
              });
              var pictureUrl;
              if (lastName == '') {
                setState(() {
                  lastName = userData.lastName;
                });
              }
              if (firstName == '') {
                setState(() {
                  firstName = userData.firstName;
                });
              }
              if (displayPicture != null) {
                // String name = firstName+lastName;
                pictureUrl = await FirestoreUpload()
                    .uploadImageToFirestore("users", firstName, displayPicture);
              } else {
                pictureUrl = userData.displayPicture;
              }
              dynamic result = await DatabaseService(uid: userData.uid)
                  .updateUserData(firstName, lastName, pictureUrl, false);
              if (result != null) {
                setState(() {
                  error = 'Could not update.';
                  loading = false;
                });
              } else {
                setState(() {
                  error = '';
                  displayPicture = null;
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
          label: loading
              ? Loading()
              : Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
        ),
      ),
    ]);
  }


// Avatar to be visible before edit
  Widget getAvatar(userData) {
    if (userData.displayPicture == null) {
      return CircleAvatar(
        radius: 50,
        backgroundColor: getColor(userData.color),
        child: Text(
          userData.firstName.substring(0, 1).toUpperCase() +
              userData.lastName.substring(0, 1).toUpperCase(),
          style: TextStyle(fontSize: 40, color: Colors.white),
        ),
      );
    } else {
      return ClipOval(
          child: Image.network(
        userData.displayPicture,
        loadingBuilder: (context, child, progress){
          return progress == null
            ? child
            : SizedBox(
              height: 100,
              width: 100,
              child: ImageLoading()
            );
        },
        fit: BoxFit.cover,
        width: 100.0,
        height: 100.0,
      ));
    }
  }

  // Avatar and icon to be visible on edit
  Widget getAvatarOnEdit(userData) {
    if(displayPicture != null){
      return ClipOval(
          child: Image.file(
        displayPicture,
        fit: BoxFit.cover,
        width: 100.0,
        height: 100.0,
      ));
    } else if (userData.displayPicture != null){
      return ClipOval(
          child: Image.network(
        userData.displayPicture,
        fit: BoxFit.cover,
        width: 100.0,
        height: 100.0,
      ));
    } else {
      return  CircleAvatar(
        radius: 50,
        backgroundColor: getColor(userData.color),
        child: Text(
          userData.firstName.substring(0, 1).toUpperCase() +
              userData.lastName.substring(0, 1).toUpperCase(),
          style: TextStyle(fontSize: 40, color: Colors.white),
        ),
      );
    }
  }
}
