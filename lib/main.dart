import 'package:flutter/material.dart';
import 'package:racher/screens/teachers/addTeacher.dart';
import 'package:racher/screens/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:racher/services/auth.dart';
import 'package:racher/models/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
        child: MaterialApp(
        initialRoute: '/', 
        routes: {
          '/' : (context) => Wrapper(),
          '/teacher' : (context) => Wrapper(),
          '/teacher/add' : (context) => AddTeacherScreen()
        },
      ),
    );
  }
}