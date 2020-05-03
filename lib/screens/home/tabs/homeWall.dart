import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:racher/models/review.dart';
import 'package:racher/models/teacher.dart';
import 'package:racher/models/user.dart';
import 'package:racher/services/database.dart';
import 'package:racher/services/reviewService.dart';
import 'package:racher/services/teacherService.dart';
import 'package:racher/shared/helperFunctions.dart';
import 'package:racher/shared/loading.dart';
import 'package:racher/shared/sharedWidget.dart';
import 'package:racher/shared/textStyles.dart';

class HomeWall extends StatefulWidget {
  @override
  _HomeWallState createState() => _HomeWallState();
}

class _HomeWallState extends State<HomeWall> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12, 12, 0, 12),
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
                    "Popular",
                    style: Style.headerTextStyle,
                  ),
            SizedBox(height: 15),
            Container(
              height: 80,
              width: double.infinity,
              child : getPopularTeacherList(),
            ),
            SizedBox(height: 25),
            Text(
                    "Reviews",
                    style: Style.headerTextStyle,
                  ),
            Padding(
              padding: const EdgeInsets.only(right: 12.0, top: 12.0),
              child: getReviewList(),
            )
          ],)
      ),
    );
  }

  Widget getPopularTeacherList(){
    return StreamBuilder<List<TeacherData>>(
      stream: TeacherService().popularTeachers,
      builder: (context, snapshot){
        if(snapshot.hasData){
          List<TeacherData> popularTeachers = snapshot.data;

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: popularTeachers.length,
            itemBuilder: (context, index){
              return Container(
                padding: EdgeInsets.only(right: 15.0),
                child: GestureDetector(
                  child: Hero(
                    tag: "teacher-${popularTeachers[index].documentId}",
                    child: SharedWidget().getAvatar(popularTeachers[index], 40.0, 32.0, 'teacher')
                    ),
                  onTap: (){
                    Navigator.pushNamed(context, '/teacher/details', arguments: {'teacher':popularTeachers[index]});
                  },
                  )
                );
            },
          );
        } else {
          return LoadingFull();
        }
      }
      );
  }

  Widget getReviewList() {
    return reviewsFound();
  }

  Widget noReviewFound() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: DottedBorder(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 10.0),
              Text(
                "Sorry. We looked everywhere and could not find any reviews. Be the first to review a teacher.",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.0),
            ],
          ),
        ),
        borderType: BorderType.RRect,
        radius: Radius.circular(10.0),
        color: Colors.black45,
        dashPattern: [4, 8],
      ),
    );
  }

  Widget reviewsFound() {
    List<Review> reviewList;

    return StreamBuilder<List<Review>>(
        stream:
            ReviewService().allReviews,
        builder: (contextReview, snapshotReview) {
          if (snapshotReview.hasData) {
            reviewList = snapshotReview.data;

            return ListView.builder(
                padding: EdgeInsets.only(top: 0, bottom: 30),
                primary: false,
                shrinkWrap: true,
                itemCount: reviewList.length,
                itemBuilder: (contextUser, reviewIndex) {
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
                            builder: (contextTeacher, snapshotTeacher) {
                              if (snapshotTeacher.hasData) {
                                TeacherData teacherData = snapshotTeacher.data;
                                return reviewCard(reviewList[reviewIndex],
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

  Widget reviewCard(Review review, UserData userData, TeacherData teacherData) {
    Color cardColor = Colors.deepPurple[600];
    String username = userData.firstName + ' ' + userData.lastName;
    if (review.rating == 4) {
      cardColor = Colors.purple[600];
    } else if (review.rating == 3) {
      cardColor = Colors.pink[600];
    } else if (review.rating == 2) {
      cardColor = Colors.red[600];
    } else if (review.rating == 1) {
      cardColor = Colors.red[700];
    }

    String dateUnder =
        HelperFunctions().getDateDiffOrDate(review.updatedDate, DateTime.now());

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      color: cardColor,
      elevation: 4,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              dense: true,
              leading: SharedWidget().getAvatar(userData, 20.0, 16.0, 'user'),
              title: Text(
                username,
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(dateUnder,
                  style: TextStyle(color: Colors.white54, fontSize: 12)),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(12, 3, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom : 3.0),
                    child: Text(teacherData.name,
                        style:
                            Style.titleTextStyle.copyWith(color: Colors.white)),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                          flex: 0,
                          child: Container(
                            child: Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.yellow[700],
                            ),
                          )),
                      Expanded(
                        flex: 2,
                        child: Padding(
                            padding: EdgeInsets.only(left: 5.0),
                            child: Text(review.rating.toString(),
                                style: TextStyle(color: Colors.white54))),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                    child: Text(
                      review.review,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
          ]),
    );
  }
}