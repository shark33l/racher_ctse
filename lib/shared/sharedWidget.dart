import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:racher/models/review.dart';
import 'package:racher/models/teacher.dart';
import 'package:racher/models/user.dart';
import 'package:racher/shared/constants.dart';
import 'package:racher/shared/helperFunctions.dart';
import 'package:racher/shared/loading.dart';
import 'package:racher/shared/textStyles.dart';


class SharedWidget {

  // Wrapped Chips
  Widget generateChips(List list, Color backgroundColor, Color textColor){
    if(list.length > 0){

      List<Widget> chipList = List<Widget>.from(list
            .map((tag) => Chip(
                  label: Text(
                    tag,
                    style: TextStyle(color: textColor),
                  ),
                  backgroundColor: backgroundColor, 
                ))
            .toList());

      return SizedBox(
        width: double.infinity,
        child: Wrap(
          spacing: 4,
          runSpacing: -8,
          direction: Axis.horizontal,
          alignment: WrapAlignment.start,
          children: chipList
        ),
      );
    } else {
      return Container(
        height: 0,
        width: 0
      );
    }
  }

  // Widget for avatar
  Widget getAvatar(objectUT, radius, fontSize, String type) {
    String userInitials;
    if(type == "teacher"){
      userInitials = objectUT.name.substring(0, 1).toUpperCase();
    } else {
      userInitials = objectUT.firstName.substring(0, 1).toUpperCase() +
              objectUT.lastName.substring(0, 1).toUpperCase();
    }
    if (objectUT.displayPicture == null) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: getColor(objectUT.color),
        child: Text(
          userInitials,
          style: TextStyle(fontSize: fontSize, color: Colors.white),
        ),
      );
    } else {
      return ClipOval(
          child: Image.network(
        objectUT.displayPicture,
        loadingBuilder: (context, child, progress){
          return progress == null
            ? child
            : SizedBox(
              height: radius * 2,
              width: radius * 2,
              child: ImageLoading()
            );
        },
        fit: BoxFit.cover,
        width: radius * 2.0,
        height: radius * 2.0,
      ));
    }
  }

  // Card for Reviews
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

  // Widget to Show if reviews are not found
  Widget noReviewFound(String textToShow) {
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
                textToShow,
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
}