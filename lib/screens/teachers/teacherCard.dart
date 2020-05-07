import 'package:flutter/material.dart';
import 'package:racher/shared/helperFunctions.dart';
import 'package:racher/shared/sharedWidget.dart';
import 'package:racher/shared/textStyles.dart';
import 'package:racher/models/teacher.dart';


// Widget for Teacher Profile Card
class TeacherCard extends StatelessWidget {

  final TeacherData teacher;

  TeacherCard(this.teacher);


  @override
  Widget build(BuildContext context) {

  List<Widget> generateChips(List list){

      List<Widget> chipList = List<Widget>.from(list
            .map((tag) => Padding(
              padding: const EdgeInsets.fromLTRB(2.0, 0, 2.0, 0),
              child: Chip(
                    label: Text(
                      tag,
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.redAccent[400],
                  ),
            ))
            .toList());

      return chipList;
  }

    final teacherThumbnail = new Container(
      margin: new EdgeInsets.symmetric(
        vertical: 16.0
      ),
      alignment: FractionalOffset.center,
      child: new Hero(
          tag: "teacher-${teacher.documentId}",
          child: SharedWidget().getAvatar(teacher, 46.0, 40.0, "teacher"),
      ),
    );



    Widget _teacherValue({value, String type}) {
      return new Container(
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Icon(type == "rating" ? Icons.star : Icons.school, size: 16, color: value.ratedUserCount !=0 ? Colors.yellow[700] : Colors.black45),
            new Container(width: 8.0),
            new Text(value.ratedUserCount !=0 ? value.rating.toString() : 'Not Rated Yet', style: TextStyle(fontSize: 14)),
            value.ratedUserCount > 0 ?
            Padding(
              padding: EdgeInsets.only(left: 4, top: 3),
              child:Text(value.ratedUserCount > 1 ? '(${value.ratedUserCount} reviews)' : '(${value.ratedUserCount} review)', style: TextStyle(fontSize: 9, color: Colors.black38)))
              : Container(),
          ]
        ),
      );
    }


    final teacherCardContent = new Container(
      margin: new EdgeInsets.fromLTRB(16.0, 42.0, 16.0, 16.0),
      constraints: new BoxConstraints.expand(),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Container(height: 4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(teacher.name, style: Style.titleTextStyle),
              Padding(
                padding: const EdgeInsets.fromLTRB(2, 7, 0, 0),
                child: Text(HelperFunctions().commaSeperatedStringFromList(teacher.academicInitials), style: Style.smallTextBoldStyle),
              ),
            ],
          ),
          new Container(height: 10.0),
          Container(
            height: 40,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: generateChips(teacher.subjects)
            ),
          ),
          SizedBox(height: 10),
          new Expanded(
                flex: 0,
                child: _teacherValue(
                  value: teacher,
                  type: 'rating')

              ),
        ],
      ),
    );

    final teacherCard = new Container(
      child: teacherCardContent,
      height: 175,
      margin: new EdgeInsets.only(top: 72.0),
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: new Offset(0.0, 10.0),
          ),
        ],
      ),
    );

    return new GestureDetector(
      onTap: (){},
      child: new Container(
        margin: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 24.0,
        ),
        child: new Stack(
          children: <Widget>[
            teacherCard,
            teacherThumbnail,
          ],
        ),
      )
    );
  }
}