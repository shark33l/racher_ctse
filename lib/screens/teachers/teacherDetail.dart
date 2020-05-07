import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:racher/models/review.dart';
import 'package:racher/models/teacher.dart';
import 'package:racher/models/user.dart';
import 'package:racher/screens/teachers/reviewForm.dart';
import 'package:racher/screens/teachers/teacherCard.dart';
import 'package:racher/services/database.dart';
import 'package:racher/services/reviewService.dart';
import 'package:racher/services/teacherService.dart';
import 'package:racher/services/uploadFirestore.dart';
import 'package:racher/shared/loading.dart';
import 'package:racher/shared/separator.dart';
import 'package:racher/shared/sharedWidget.dart';
import 'package:racher/shared/textStyles.dart';

class TeacherDetails extends StatefulWidget {
  @override
  _TeacherDetailsState createState() => _TeacherDetailsState();
}

class _TeacherDetailsState extends State<TeacherDetails> {
  Map data = {};
  TeacherData teacher = TeacherData();
  File displayPicture;
  File coverPicture;

  Future getImage(String type) async {
    return await ImagePicker.pickImage(source: ImageSource.gallery);
  }

// Return function depending on choice of pupup menu
  void _select(choice) async {
    var pictureUrl;
    var data;
    String pictureName;
    if (choice.value == 'addCover' || choice.value == 'updateCover') {

      // Updating Cover Picture
      pictureName = teacher.name + "cover";
      dynamic coverPicture = await getImage("coverPicture");
      if(coverPicture != null){
        pictureUrl = await FirestoreUpload()
            .uploadImageToFirestore("teachers", pictureName, coverPicture);
      // Set Data
      data = {"coverPicture": pictureUrl};
      }
    } else if (choice.value == 'removeCover') {

      // Removing Cover Picture
      // Set Data
      data = {"coverPicture": null};
    } else if (choice.value == "updateDp") {

      // Updating Display Pictue
      pictureName = teacher.name;
      dynamic displayPicture = await getImage("coverPicture");

      if(displayPicture != null){
        pictureUrl = await FirestoreUpload()
            .uploadImageToFirestore("teachers", pictureName, displayPicture);
      
      // Set Data
      data = {"displayPicture": pictureUrl};
      }
    }
    if(data != null){
      await TeacherService().updateTeacherData(teacher.documentId, data);
    }

  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    teacher = data["teacher"];


// Bottom Sheet for Review Form
    void _showReviewPanel() {
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return Wrap(
              children:<Widget>[ 
              Container(
                height: 450,
                padding:
                    new EdgeInsets.symmetric(horizontal: 32.0, vertical: 15.0),
                child: ReviewForm(
                  teacher: teacher,
                ),
              ),
                          ]
            );
          });
    }

    return StreamBuilder<TeacherData>(
        stream: TeacherService(teacherId: teacher.documentId).teacherById,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            teacher = snapshot.data;
          }
          return Scaffold(
              extendBodyBehindAppBar: true,
              floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.comment),
                  backgroundColor: Colors.redAccent[400],
                  onPressed: () {
                    _showReviewPanel();
                  }),
              appBar: AppBar(
                leading: BackButton(color: Colors.white),
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: <Widget>[
                  PopupMenuButton<CoverChoice>(
                    onSelected: _select,
                    itemBuilder: (BuildContext context) {
                      List<CoverChoice> choicesCover = choicesWOCover;
                      if (teacher.coverPicture != null) {
                        choicesCover = choicesWCover;
                      }
                      return choicesCover.map((CoverChoice choice) {
                        return PopupMenuItem<CoverChoice>(
                          value: choice,
                          child: Text(choice.title),
                        );
                      }).toList();
                    },
                  ),
                ],
              ),
              body: Container(
                  constraints: new BoxConstraints.expand(),
                  color: Colors.white,
                  child: Stack(
                    children: <Widget>[
                      getCoverPicture(),
                      getGradient(),
                      getContent()
                    ],
                  )));
        });
  }

// Cover Picture
  Container getCoverPicture() {
    return new Container(
      child: teacher.coverPicture != null
          ? Image.network(
              teacher.coverPicture,
              fit: BoxFit.cover,
              height: 300.0,
            )
          : Image.asset(
              'assets/racher_cover-01.jpg',
              fit: BoxFit.cover,
              height: 300.0,
            ),
      constraints: new BoxConstraints.expand(height: 300.0),
    );
  }

// Gradient for Cover Picture
  Container getGradient() {
    return new Container(
      margin: new EdgeInsets.only(top: 100.0),
      height: 200.0,
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: <Color>[Colors.transparent, Colors.white],
          stops: [0.0, 0.9],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(0.0, 1.0),
        ),
      ),
    );
  }


// Body Content View
  Widget getContent() {
    final _firstTitle = "Bio";
    final _secondTitle = "Reviews";
    return new Stack(children: <Widget>[
      Container(
        child: new ListView(
          padding: new EdgeInsets.fromLTRB(0.0, 72.0, 0.0, 32.0),
          children: <Widget>[
            new TeacherCard(teacher),
            new Container(
              padding:
                  new EdgeInsets.symmetric(horizontal: 32.0, vertical: 5.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    _firstTitle,
                    style: Style.headerTextStyle,
                  ),
                  new Separator(),
                  new Text(teacher.description, style: Style.commonTextStyle),
                  SizedBox(height: 10),
                  Column(
                    children: <Widget>[
                      Container(
                          child: Row(
                        children: <Widget>[
                          Icon(Icons.school,
                              size: 20, color: Colors.deepPurple[700]),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text("Institutes worked at"),
                          )
                        ],
                      )),
                      SharedWidget().generateChips(
                          teacher.institutes, Colors.black45, Colors.white)
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      DraggableScrollableSheet(
          initialChildSize: 0.2,
          minChildSize: 0.075,
          maxChildSize: 0.89,
          builder: (context, scrollableController) {
            return Container(
                padding:
                    new EdgeInsets.fromLTRB(32.0, 15.0, 32.0, 0),
                height: double.infinity,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0)),
                  boxShadow: <BoxShadow>[
                    new BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: new Offset(0.0, -3.0),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollableController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                        _secondTitle,
                        style: Style.headerTextStyle,
                      ),
                      SizedBox(height: 7),
                      Separator(),
                      getReviewList(),
                    ],
                  ),
                ));
          })
    ]);
  }

  Widget getReviewList() {
    if (teacher.ratedUserCount == 0) {
      String textToShow = "Sorry. We looked everywhere and could not find reviews for ${teacher.name}. Be the first to review this teacher.";
      return SharedWidget().noReviewFound(textToShow);
    } else {
      return reviewsFound();
    }
  }

// Widget to show if reviews are found
  Widget reviewsFound() {
    List<Review> reviewList;

    return StreamBuilder<List<Review>>(
        stream:
            ReviewService(reviewId: teacher.documentId).specificTeacherReviews,
        builder: (context, snapshotReview) {
          if (snapshotReview.hasData) {
            reviewList = snapshotReview.data;
            return ListView.builder(
                padding: EdgeInsets.only(top: 0, bottom: 30),
                primary: false,
                shrinkWrap: true,
                itemCount: reviewList.length,
                itemBuilder: (context, reviewIndex) {
                  return StreamBuilder<UserData>(
                      stream:
                          DatabaseService(uid: reviewList[reviewIndex].userId)
                              .userData,
                      builder: (context, snapshotUser) {
                        if (snapshotUser.hasData) {
                          UserData userData = snapshotUser.data;
                          return StreamBuilder<TeacherData>(
                            stream: TeacherService(
                                    teacherId:
                                        reviewList[reviewIndex].teacherId)
                                .teacherById,
                            builder: (context, snapshotTeacher) {
                              if (snapshotTeacher.hasData) {
                                TeacherData teacherData = snapshotTeacher.data;
                                return SharedWidget().reviewCard(reviewList[reviewIndex],
                                    userData, teacherData);
                              } else {
                                return Container();
                              }
                            },
                          );
                        } else {
                          return Container();
                        }
                      });
                });
          } else {
            return LoadingFull();
          }
        });
  }
}


// Choices for the Popup Menu button dropdown
class CoverChoice {
  const CoverChoice({this.title, this.icon, this.value});

  final String title;
  final IconData icon;
  final String value;
}

const List<CoverChoice> choicesWCover = const <CoverChoice>[
  const CoverChoice(
      title: 'Update Display Picture',
      icon: Icons.camera_alt,
      value: "updateDp"),
  const CoverChoice(
      title: 'Remove Cover', icon: Icons.remove, value: "removeCover"),
  const CoverChoice(
      title: 'Update Cover', icon: Icons.camera_alt, value: "updateCover"),
];
const List<CoverChoice> choicesWOCover = const <CoverChoice>[
  const CoverChoice(
      title: 'Update Display Picture',
      icon: Icons.camera_alt,
      value: "updateDp"),
  const CoverChoice(
      title: 'Add Cover', icon: Icons.camera_alt, value: "addCover"),
];
