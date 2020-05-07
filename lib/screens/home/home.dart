import 'package:flutter/material.dart';
import 'package:racher/screens/home/tabs/homeWall.dart';
import 'package:racher/screens/home/tabs/profile.dart';
import 'package:racher/screens/home/tabs/teacherList.dart';

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
  return Container(
        height: 600,
        width: double.infinity,
        child: DefaultTabController(
            length: 3,
            child: Scaffold(
                appBar: AppBar(
                  elevation: 0.0,
                  backgroundColor: Colors.transparent,
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(33),
                    child: Container(
                      color: Colors.transparent,
                      child: SafeArea(
                        child: Column(
                          children: <Widget>[
                            TabBar(
                                indicator: UnderlineTabIndicator(
                                    borderSide: BorderSide(
                                        color: Colors.redAccent[400], width: 4.0),
                                    insets: EdgeInsets.fromLTRB(
                                        60.0, 0, 60.0, 0)),
                                indicatorWeight: 15,
                                indicatorSize: TabBarIndicatorSize.label,
                                labelColor: Colors.deepPurple[700],
                                labelStyle: TextStyle(
                                    fontSize: 12,
                                    letterSpacing: 1.3,
                                    fontWeight: FontWeight.w500),
                                unselectedLabelColor: Colors.black26,
                                tabs: [
                                  Tab(
                                    text: "HOME",
                                    icon: Icon(Icons.home, size: 25),
                                  ),
                                  Tab(
                                    text: "TEACHERS",
                                    icon: Icon(Icons.school, size: 25),
                                  ),
                                  Tab(
                                    text: "PROFILE",
                                    icon: Icon(Icons.supervised_user_circle,
                                        size: 25),
                                  ),
                                ])
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                body: TabBarView(
                  children: <Widget>[
                    Center(
                      child: HomeWall(),
                    ),
                    Center(
                      child: TeacherList(),
                    ),
                    ProfilePage()
                  ],
                )
              )
            )
          );
  }
}