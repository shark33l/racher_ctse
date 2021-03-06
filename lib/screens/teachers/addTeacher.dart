import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:racher/services/teacherService.dart';
import 'package:racher/services/uploadFirestore.dart';
import 'package:racher/shared/constants.dart';
import 'package:racher/shared/loading.dart';
import 'package:racher/shared/sharedWidget.dart';

class AddTeacherScreen extends StatefulWidget {
  @override
  _AddTeacherScreenState createState() => _AddTeacherScreenState();
}

class _AddTeacherScreenState extends State<AddTeacherScreen> {
  final _formKey = GlobalKey<FormState>();
  final TeacherService teacherService = TeacherService();

  // text Field State
  String name = '';
  String description = '';
  String subjects = '';
  List subjectList = [];
  String currentInstitute = '';
  String institutes = '';
  List instituteList = [];
  String academicInitials = '';
  List academicInitialsList = [];

  // Error States
  String error = '';

  // Loading State
  bool loading = false;

  File displayPicture;

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      displayPicture = tempImage;
    });
  }

  // Form SizedBox size
  double formSizedBoxHeight = 10.0;

  emptyStates() {
    setState(() {
      name = '';
      description = '';
      subjects = '';
      subjectList = [];
      currentInstitute = '';
      institutes = '';
      instituteList = [];
      academicInitials = '';
      academicInitialsList = [];
      displayPicture = null;
    });
  }

  getValueFromStringList(String val) {
    List newList = [];
    if (val.contains(',')) {
      List listVal = val.split(',');
      for (int i = 0; i < listVal.length; i++) {
        String valueToInsert = listVal[i].toString();
        if (listVal[i].toString().startsWith(' ')) {
          valueToInsert = listVal[i].toString().substring(1);
        }
        if (valueToInsert.isNotEmpty) {
          newList.add(valueToInsert);
        }
      }
    } else if (val.isNotEmpty) {
      newList.add(val);
    }

    return newList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: BackButton(color: Colors.black),
          backgroundColor: Colors.transparent,
          title: Text(
            'Add Teacher',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          elevation: 0),
      body: Builder(
        builder: (contextScaf) => SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 50.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 100,
                    decoration: BoxDecoration(
                        border: Border.all(
                            style: BorderStyle.solid, color: Colors.black26),
                        borderRadius: BorderRadius.circular(50)),
                    child: InkWell(
                      onTap: () {
                        getImage();
                      },
                      highlightColor: Colors.deepPurple[700].withOpacity(0.5),
                      splashColor: Colors.deepPurpleAccent[400],
                      borderRadius: BorderRadius.circular(50),
                      child: displayPicture == null
                          ? CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.transparent,
                              child: Icon(Icons.add_a_photo),
                            )
                          : ClipOval(
                              child: Image.file(
                              displayPicture,
                              fit: BoxFit.cover,
                              width: 100.0,
                              height: 100.0,
                            )),
                    ),
                  ),
                  displayPicture == null
                      ? SizedBox(
                          child: Container(),
                        )
                      : SizedBox(
                          child: FlatButton.icon(
                          icon: Icon(Icons.close),
                          label: Text("Remove Image"),
                          color: Colors.white,
                          onPressed: () {
                            setState(() {
                              displayPicture = null;
                            });
                          },
                        )),
                  SizedBox(height: 20),
                  TextFormField(
                    validator: (val) =>
                        val.isEmpty ? 'Teacher\'s Name cannot be empty' : null,
                    onChanged: (val) {
                      setState(() => name = val);
                    },
                    style: TextStyle(color: Colors.black87),
                    decoration: textInputDecoration.copyWith(
                        hintText: 'Enter Teacher\'s Name',
                        labelText: 'Teacher\'s Name'),
                  ),
                  SizedBox(height: formSizedBoxHeight),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5,
                    validator: (val) =>
                        val.isEmpty ? 'Description cannot be empty' : null,
                    onChanged: (val) {
                      setState(() => description = val);
                    },
                    style: TextStyle(color: Colors.black87),
                    decoration: textInputDecoration.copyWith(
                        hintText: 'Enter a short description',
                        labelText: 'Description'),
                  ),
                  SizedBox(height: formSizedBoxHeight),
                  TextFormField(
                    validator: (val) =>
                        val.isEmpty ? 'Subjects cannot be empty' : null,
                    onChanged: (val) {
                      setState(() {
                        subjects = val;
                        subjectList = getValueFromStringList(val);
                      });
                    },
                    style: TextStyle(color: Colors.black87),
                    decoration: textInputDecoration.copyWith(
                        hintText: 'Use comma to seperate.',
                        labelText: 'Subjects'),
                  ),
                  SharedWidget().generateChips(
                      subjectList, Colors.redAccent[400], Colors.white),
                  SizedBox(height: formSizedBoxHeight),
                  TextFormField(
                    minLines: 1,
                    maxLines: 3,
                    validator: (val) =>
                        val.isEmpty ? 'Institutes cannot be empty' : null,
                    onChanged: (val) {
                      setState(() {
                        institutes = val;
                        instituteList = getValueFromStringList(val);
                      });
                    },
                    style: TextStyle(
                      color: Colors.black87,
                    ),
                    decoration: textInputDecoration.copyWith(
                        hintText: 'Use comma to seperate.',
                        labelText: 'Institutes'),
                  ),
                  SharedWidget().generateChips(
                      instituteList, Colors.redAccent[400], Colors.white),
                  SizedBox(height: formSizedBoxHeight),
                  TextFormField(
                    onChanged: (val) {
                      setState(() => currentInstitute = val);
                    },
                    style: TextStyle(
                      color: Colors.black87,
                    ),
                    decoration: textInputDecoration.copyWith(
                        hintText: 'Enter current Institute of work',
                        labelText: 'Current Institute'),
                  ),
                  SizedBox(height: formSizedBoxHeight),
                  TextFormField(
                    minLines: 1,
                    maxLines: 2,
                    onChanged: (val) {
                      setState(() {
                        academicInitials = val;
                        academicInitialsList = getValueFromStringList(val);
                      });
                    },
                    style: TextStyle(
                      color: Colors.black87,
                    ),
                    decoration: textInputDecoration.copyWith(
                        hintText: 'Use comma to seperate.',
                        labelText: 'Academic Initials'),
                  ),
                  SharedWidget().generateChips(academicInitialsList,
                      Colors.redAccent[400], Colors.white),
                  SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: RaisedButton.icon(
                      color: Colors.deepPurple[700],
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      label: loading
                          ? Loading()
                          : Text(
                              'Add Teacher',
                              style: TextStyle(color: Colors.white),
                            ),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            loading = true;
                          });
                          var pictureUrl;
                          if (displayPicture != null) {
                            pictureUrl = await FirestoreUpload()
                                .uploadImageToFirestore(
                                    "teachers", name, displayPicture);
                          }
                          dynamic result = teacherService.addTeacherData(
                              name,
                              description,
                              subjectList,
                              instituteList,
                              currentInstitute,
                              academicInitialsList,
                              pictureUrl);
                          if (result == null) {
                            setState(() {
                              error = 'Could not add Teacher. Please Try again';
                              loading = false;
                            });
                          } else {
                            loading = false;
                            emptyStates();
                            _formKey.currentState.reset();
                            Scaffold.of(contextScaf).showSnackBar(SnackBar(
                              backgroundColor: Colors.greenAccent[700],
                              content: Text("Done! Teacher added.",
                                  style: TextStyle(color: Colors.white)),
                            ));
                          }
                        }
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
            )),
      ),
    );
  }
}
