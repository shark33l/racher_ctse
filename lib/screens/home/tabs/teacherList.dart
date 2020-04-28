import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:racher/services/teacherService.dart';
import 'package:dotted_border/dotted_border.dart';

class TeacherList extends StatefulWidget {
  @override
  _TeacherListState createState() => _TeacherListState();
}

class _TeacherListState extends State<TeacherList> {

  var queryResultSet = [];
  var tempSearchStore = [];
  var resultsFound = false;

  initiateSearch(value){
    if(value.length == 0){
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    if (queryResultSet.length == 0 && value.length == 1){
      TeacherService().searchByName(value).then((QuerySnapshot docs){
        for (int i = 0; i < docs.documents.length; i++){
          queryResultSet.add(docs.documents[i].data);
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if(element['name'].toLowercase().startsWith(value.toLowercase())){
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }

    if (tempSearchStore.length == 0){
      setState(() {
        resultsFound = false;
      });
    } else {
      setState(() {
        resultsFound = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10.0),
          child: TextField(
            onChanged: (val) {
              initiateSearch(val);
            },
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color : Colors.black,
                size: 20.0,
                ),
                contentPadding: EdgeInsets.only(left: 25.0),
                hintText: 'Search by name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0)
                )
            ),
          ),
        ),
        SizedBox(height: 10.0,),
        getTeacherListView()
      ],
    );
  }

  Widget getTeacherListView() {
    return resultsFound ? Text('results found')
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
                "Sorry. Could not find the teachers. Try adding a teacher to review.",
                textAlign: TextAlign.center,
                ),
              FlatButton.icon(onPressed: (){}, icon: Icon(Icons.add), label: Text("Add Teacher"))
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
          dashPattern: [4,8],
      ),
    );
  }
}