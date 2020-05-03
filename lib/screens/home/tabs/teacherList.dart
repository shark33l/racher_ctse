import 'package:flutter/material.dart';
import 'package:racher/models/teacher.dart';
import 'package:racher/shared/constants.dart';
import 'package:racher/services/teacherService.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:racher/shared/error.dart';
import 'package:racher/shared/loading.dart';

class TeacherList extends StatefulWidget {
  @override
  _TeacherListState createState() => _TeacherListState();
}

class _TeacherListState extends State<TeacherList> {
  final TeacherService teacherService = TeacherService();

  var queryResultSet = [];
  var tempSearchStore = [];
  var resultsFound = false;
  var searchValue = "";

  getSnapshotToQueries(teacherList) {
    queryResultSet = [];
    teacherList.forEach((teacher){
      queryResultSet.add(teacher);
    });
    queryResultSet.sort((a, b) {
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

    if (searchValue.length == 0) {
      tempSearchStore = queryResultSet;
      if (tempSearchStore.length != 0) {
        resultsFound = true;
      }
    }
  }

  initiateSearch(String value) {
    if (value.length == 0) {
      setState(() {
        tempSearchStore = queryResultSet;
      });
    }

    if (queryResultSet.length > 0 && value.length > 0) {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element.name
            .toString()
            .toLowerCase()
            .startsWith(value.toLowerCase())) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }

    if (tempSearchStore.length == 0) {
      setState(() {
        resultsFound = false;
      });
    } else {
      setState(() {
        resultsFound = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TeacherData>>(
        stream: TeacherService().allTeachers,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            getSnapshotToQueries(snapshot.data);

            return Scaffold(
              resizeToAvoidBottomPadding: false,
              floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.person_add),
                  backgroundColor: Colors.redAccent[400],
                  onPressed: () {
                    Navigator.pushNamed(context, '/teacher/add');
                  }),
              body: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextField(
                      onChanged: (val) {
                        initiateSearch(val);
                        setState(() {
                          searchValue = val;
                        });
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.black,
                          size: 20.0,
                        ),
                        contentPadding: EdgeInsets.only(left: 25.0),
                        hintText: 'Search by name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black87)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.deepPurple[400])),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  getTeacherListView()
                ],
              ),
            );
          } else if (snapshot.hasError) {
            CustomErrorMessage();
          } else {
            return LoadingFull();
          }
        });
  }

  Widget getTeacherListView() {
    return resultsFound
        ? Expanded(
            child: ListView.builder(
                padding: EdgeInsets.only(bottom: 25),
                itemCount: tempSearchStore.length,
                itemBuilder: (context, index) {
                  return makeCard(tempSearchStore[index]);
                }),
          )
        : Padding(
            padding: const EdgeInsets.all(30.0),
            child: DottedBorder(
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    Text(
                      "Sorry. Could not find teachers. Try adding a teacher to review.",
                      textAlign: TextAlign.center,
                    ),
                    FlatButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/teacher/add');
                        },
                        icon: Icon(Icons.add),
                        label: Text("Add Teacher"))
                  ],
                ),
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(10),
                //   border: Border.all(
                //     width: 1.0,
                //     color: Colors.black26,
                //   )
              ),
              borderType: BorderType.RRect,
              radius: Radius.circular(10.0),
              color: Colors.black45,
              dashPattern: [4, 8],
            ),
          );
  }

  Card makeCard(teacher) => Card(
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.transparent),
          child: makeListTile(teacher),
        ),
      );

  ListTile makeListTile(teacher) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.black26))),
          child: Hero(
            tag: "teacher-${teacher.documentId}",
            child: getAvatar(teacher)
            ),
        ),
        title: Text(
          teacher.name,
          style: TextStyle(color: Colors.black),
        ),
        subtitle: Row(
          children: <Widget>[
            Expanded(
                flex: 0,
                child: Container(
                  // tag: 'hero',
                  // child: LinearProgressIndicator(
                  //     backgroundColor: Colors.blueGrey[50],
                  //     value: 4/5,
                  //     valueColor: AlwaysStoppedAnimation(Colors.greenAccent[700])),
                  child: Icon(
                    Icons.star,
                    size: 16,
                    color: teacher.ratedUserCount != 0
                        ? Colors.yellow[700]
                        : Colors.black45,
                  ),
                )),
            Expanded(
              flex: 2,
              child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                      teacher.ratedUserCount != 0
                          ? teacher.rating.toString()
                          : "Not rated",
                      style: TextStyle(color: Colors.black45))),
            )
          ],
        ),
        trailing: Icon(Icons.keyboard_arrow_right,
            color: Colors.deepPurple[700], size: 30.0),
        onTap: () {
          Navigator.pushNamed(context, '/teacher/details', arguments: {'teacher':teacher});
        },
      );

  Widget getAvatar(teacher) {
    if (teacher.displayPicture == null) {
      return CircleAvatar(
        radius: 25,
        backgroundColor: getColor(teacher.color),
        child: Text(
          teacher.name.substring(0, 1).toUpperCase(),
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      );
    } else {
      return ClipOval(
          child: Image.network(
        teacher.displayPicture,
        loadingBuilder: (context, child, progress){
          return progress == null
            ? child
            : SizedBox(
              height: 50,
              width: 50,
              child: ImageLoading()
            );
        },
        fit: BoxFit.cover,
        width: 50.0,
        height: 50.0,
      ));
    }
  }
}
