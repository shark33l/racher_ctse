import 'package:flutter/material.dart';

// Error Message Filter
class CustomErrorMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      child: Column(
        children: <Widget>[
          Icon(Icons.error_outline, size: 40,),
          SizedBox(height: 20,),
          Text("Oops!", style: TextStyle(fontSize: 50,)),
          SizedBox(height: 10,),
          Text("Something happened! Try again.", style: TextStyle(color: Colors.black45),)
        ]
      )
    );
  }
}