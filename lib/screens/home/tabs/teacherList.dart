import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:racher/services/teacherService.dart';
import 'package:dotted_border/dotted_border.dart';
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

  getSnapshotToQueries(snapshot){
    queryResultSet = [];


    for(int i=0; i < snapshot.documents.length; i++){
      queryResultSet.add(snapshot.documents[i].data);
    }
    queryResultSet.sort((a, b) {
      return a['name'].toLowerCase().compareTo(b['name'].toLowerCase());
    });

    if(searchValue.length == 0){
      tempSearchStore = queryResultSet;
      resultsFound = true;
    }
  }

  initiateSearch(String value){
    if(value.length == 0){
      setState(() {
        tempSearchStore = queryResultSet;
      });
    }

    if(queryResultSet.length > 0 && value.length > 0){
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if(element['name'].toString().toLowerCase().startsWith(value.toLowerCase())){
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
        resultsFound = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      stream: TeacherService().allTeachers,
      builder: (context, snapshot) {

        if(snapshot.hasData){
          getSnapshotToQueries(snapshot.data);

          return Scaffold(
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.person_add),
                backgroundColor: Colors.redAccent[400],
                onPressed: (){
                  Navigator.pushNamed(context, '/teacher/add');
                }
              ),
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
                        color : Colors.black,
                        size: 20.0,
                        ),
                        contentPadding: EdgeInsets.only(left: 25.0),
                        hintText: 'Search by name',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0),),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple[400])),
                    ),
                  ),
                ),
                SizedBox(height: 10.0,),
                getTeacherListView()
              ],
            ),
          );
        } else {
          return LoadingFull();
        }
      }
    );
  }

  Widget getTeacherListView() {

    return resultsFound ? 
    Expanded(
      child: ListView.builder(
        itemCount: tempSearchStore.length,
        itemBuilder: (context, index){
          return makeCard(tempSearchStore[index]);
        }
        ),
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
              FlatButton.icon(onPressed: (){
                Navigator.pushNamed(context, '/teacher/add');
              }, icon: Icon(Icons.add), label: Text("Add Teacher"))
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

  Widget teacherCardTemplate(teacher){
    return Card(
      margin: EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                radius: 12,
                backgroundColor: Colors.deepPurple[700],
                child: Text(
                    teacher["name"].substring(0, 1).toUpperCase(),
                    style: TextStyle(fontSize: 14, color: Colors.white
                    ),
                  ),
              ),
              SizedBox(width: 15,),
              Text(
                teacher["name"],
                style: TextStyle(
                  fontSize : 20
                )
              )
              ],
              ),
              SizedBox(height: 10,),
              SizedBox(
                width: double.infinity,
                child: Text(
                  teacher["subjects"].toString(),
                  textAlign: TextAlign.left,
                ),
              )
          ]
        ),
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
    contentPadding:
        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    leading: Container(
      padding: EdgeInsets.only(right: 12.0),
      decoration: new BoxDecoration(
          border: new Border(
              right: new BorderSide(width: 1.0, color: Colors.black26))),
      child: CircleAvatar(
        backgroundColor: Colors.deepPurple[700],
        child: Text(
          teacher["name"].substring(0, 1).toUpperCase(),
          style: TextStyle(fontSize: 16, color: Colors.white
          ),
        ),
      ),
    ),
    title: Text(
      teacher["name"],
      style: TextStyle(color: Colors.black),
    ),


    subtitle: Row(
      children: <Widget>[
        Expanded(
            flex: 1,
            child: Container(
              // tag: 'hero',
              child: LinearProgressIndicator(
                  backgroundColor: Colors.blueGrey[50],
                  value: 4/5,
                  valueColor: AlwaysStoppedAnimation(Colors.greenAccent[700])),
            )),
        Expanded(
          flex: 4,
          child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text("subject",
                  style: TextStyle(color: Colors.black45))),
        )
      ],
    ),
    trailing:
        Icon(Icons.keyboard_arrow_right, color: Colors.deepPurple[700], size: 30.0),
    onTap: () {
      print(teacher["name"]);
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => DetailPage()));
    },
  );
}