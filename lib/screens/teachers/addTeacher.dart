import 'package:flutter/material.dart';
import 'package:racher/services/teacherService.dart';
import 'package:racher/shared/constants.dart';
import 'package:racher/shared/loading.dart';


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

  // Form SizedBox size
  double formSizedBoxHeight = 10.0;

  emptyStates(){
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
    });
  }

  getValueFromStringList(String val){
    List newList = [];
    if(val.contains(',')){
      List listVal = val.split(',');
      for( int i=0; i < listVal.length; i++){
        String valueToInsert = listVal[i].toString();
        if(listVal[i].toString().startsWith(' ')){
          valueToInsert = listVal[i].toString().substring(1);
        }
        if(valueToInsert.isNotEmpty){
          newList.add(valueToInsert);
        }
      }
    } else if (val.isNotEmpty){
      newList.add(val);
    }

    return newList;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black
        ),
        backgroundColor : Colors.transparent,
        title: Text('Add Teacher',
        style: TextStyle(color: Colors.black),),
        centerTitle: true,
        elevation: 0
      ),
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
                        style: BorderStyle.solid, color: Colors.black26
                      ),
                      borderRadius: BorderRadius.circular(50)
                    ),
                    child: InkWell(
                      onTap: (){

                      },
                      highlightColor: Colors.deepPurple[700].withOpacity(0.5),
                      splashColor: Colors.deepPurpleAccent[400],
                      borderRadius: BorderRadius.circular(50),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.transparent,
                        child: Icon(Icons.add_a_photo),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    validator: (val) => val.isEmpty ? 'Teacher\'s Name cannot be empty' : null,
                    onChanged: (val) {
                      setState(() => name = val);
                    },
                    style: TextStyle(color: Colors.black87),
                    decoration: textInputDecoration.copyWith(hintText:'Enter Teacher\'s Name', labelText: 'Teacher\'s Name'),
                  ),
                  SizedBox(height: formSizedBoxHeight),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5,
                    validator: (val) => val.isEmpty ? 'Description cannot be empty' : null,
                    onChanged: (val) {
                      setState(() => description = val);
                    },
                    style: TextStyle(color: Colors.black87),
                    decoration: textInputDecoration.copyWith(hintText:'Enter a short description', labelText: 'Description'),
                  ),
                  SizedBox(height: formSizedBoxHeight),
                  TextFormField(
                    validator: (val) => val.isEmpty ? 'Subjects cannot be empty' : null,
                    onChanged: (val) {
                      setState(() {
                        subjects = val;
                        subjectList = getValueFromStringList(val);
                      });
                    },
                    style: TextStyle(color: Colors.black87),
                    decoration: textInputDecoration.copyWith(hintText:'Use comma to seperate.', labelText: 'Subjects'),
                  ),
                  generateChips(subjectList),
                  SizedBox(height: formSizedBoxHeight),
                  TextFormField(
                    minLines: 1,
                    maxLines: 3,
                    validator: (val) => val.isEmpty ? 'Institutes cannot be empty' : null,
                    onChanged: (val) {
                      setState((){
                        institutes= val;
                        instituteList = getValueFromStringList(val);
                      });
                    },
                    style: TextStyle(color: Colors.black87,),
                    decoration: textInputDecoration.copyWith(hintText:'Use comma to seperate.', labelText: 'Institutes'),
                  ),
                  generateChips(instituteList),
                  SizedBox(height: formSizedBoxHeight),
                  TextFormField(
                    onChanged: (val) {
                      setState(() => currentInstitute = val);
                    },
                    style: TextStyle(color: Colors.black87,),
                    decoration: textInputDecoration.copyWith(hintText:'Enter current Institute of work', labelText: 'Current Institute'),
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
                    style: TextStyle(color: Colors.black87,),
                    decoration: textInputDecoration.copyWith(hintText:'Use comma to seperate.', labelText: 'Academic Initials'),
                  ),
                  generateChips(academicInitialsList),
                  SizedBox(height: formSizedBoxHeight),
                  SizedBox(
                    width: double.infinity,
                    child: RaisedButton.icon(
                      color: Colors.deepPurple[700],
                      icon: Icon(Icons.add, color: Colors.white,),
                      label: loading ? Loading() : Text(
                        'Add Teacher',
                        style: TextStyle(color: Colors.white),
                      ),
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      onPressed: () async {
                        if (_formKey.currentState.validate()){
                          setState(() {loading = true;});
                          dynamic result = teacherService.addTeacherData(name, description, subjectList, instituteList, currentInstitute, academicInitialsList, null);
                          if (result == null) {
                            setState(() {
                              error = 'Could not add Teacher. Please Try again';
                              loading = false;
                            });
                          } else {
                            loading = false;
                            emptyStates();
                            _formKey.currentState.reset();
                            Scaffold.of(contextScaf).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.greenAccent[700],
                                content: Text(
                                  "Done! Teacher added.",
                                  style: TextStyle(color: Colors.white)
                                ),
                                )
                              );
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
            )
            ),
      ),
    );
  }

  Widget generateChips(List list){
    if(list.length > 0){

      List<Widget> chipList = List<Widget>.from(list
            .map((tag) => Chip(
                  label: Text(
                    tag,
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.redAccent[400],
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
}