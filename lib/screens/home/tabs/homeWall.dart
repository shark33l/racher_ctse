import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:racher/models/review.dart';
import 'package:racher/models/teacher.dart';
import 'package:racher/models/user.dart';
import 'package:racher/services/database.dart';
import 'package:racher/services/reviewService.dart';
import 'package:racher/services/teacherService.dart';
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
      padding: EdgeInsets.fromLTRB(12, 12, 0, 0),
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

// Get top 10 popular teachers by rating
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

// Widget to show if reviews are found
// Multiple Streambuilders are used to connect multiple collections
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