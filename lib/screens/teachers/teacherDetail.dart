import 'package:flutter/material.dart';
import 'package:racher/models/teacher.dart';
import 'package:racher/screens/teachers/teacherCard.dart';
import 'package:racher/shared/separator.dart';
import 'package:racher/shared/textStyles.dart';

class TeacherDetails extends StatefulWidget {
  @override
  _TeacherDetailsState createState() => _TeacherDetailsState();
}

class _TeacherDetailsState extends State<TeacherDetails> {

  Map data = {};
  TeacherData teacher = TeacherData();

  void _select(choice){
    print(choice);
  }

  @override
  Widget build(BuildContext context) {

    data = ModalRoute.of(context).settings.arguments;
    teacher = data["teacher"];

    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.comment),
                  backgroundColor: Colors.redAccent[400],
                  onPressed: () {
                  }),
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white
        ),
        backgroundColor : Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          PopupMenuButton<CoverChoice>(
              onSelected: _select,
              itemBuilder: (BuildContext context) {
                List<CoverChoice> choicesCover = choicesWOCover;
                if(teacher.coverPicture != null){
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
        constraints : new BoxConstraints.expand(),
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            getCoverPicture(),
            getGradient(),
            getContent()
          ],
        )
      )
    );
  }

  Container getCoverPicture () {
    return new Container(
            child: teacher.coverPicture != null ? Image.network(teacher.coverPicture,
              fit: BoxFit.cover,
              height: 300.0,
            ) : Image.asset(
              'assets/racher_cover-01.jpg',
              fit: BoxFit.cover,
              height: 300.0,
            ),
            constraints: new BoxConstraints.expand(height: 300.0),
          );
  }

  Container getGradient() {
     return new Container(
       margin: new EdgeInsets.only(top: 100.0),
       height: 200.0,
       decoration: new BoxDecoration(
         gradient: new LinearGradient(
           colors: <Color>[
             Colors.transparent,
             Colors.white
          ],
          stops: [0.0, 0.9],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(0.0, 1.0),
        ),
      ),
    );
  }

  Container getContent() {
    final _overviewTitle = "Reviews".toUpperCase();
    return new Container(
            child: new ListView(
              padding: new EdgeInsets.fromLTRB(0.0, 72.0, 0.0, 32.0),
              children: <Widget>[
                new TeacherCard(teacher),
                new Container(
                  padding: new EdgeInsets.symmetric(horizontal: 32.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(_overviewTitle,
                        style: Style.headerTextStyle,),
                      new Separator(),
                      new Text(
                          teacher.description, style: Style.commonTextStyle),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}

class CoverChoice {
  const CoverChoice({this.title, this.icon, this.value});

  final String title;
  final IconData icon;
  final String value;
}

const List<CoverChoice> choicesWCover = const <CoverChoice>[
  const CoverChoice(title: 'Update Display Picture', icon: Icons.camera_alt, value: "updateDp"),
  const CoverChoice(title: 'Remove Cover', icon: Icons.remove, value: "remove"),
  const CoverChoice(title: 'Update Cover', icon: Icons.camera_alt, value: "update"),
];
const List<CoverChoice> choicesWOCover = const <CoverChoice>[
  const CoverChoice(title: 'Update Display Picture', icon: Icons.camera_alt, value: "updateDp"),
  const CoverChoice(title: 'Add Cover', icon: Icons.camera_alt, value: "add"),
];