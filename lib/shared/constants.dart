import 'package:flutter/material.dart';

// Text Input Styles
final textInputDecoration = InputDecoration(
    hintStyle: TextStyle(color: Colors.black45),
    labelStyle: TextStyle(color: Colors.black87),
    enabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
    focusedBorder: 
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple[400])),
    );
final largeTextInputDecoration = InputDecoration(
    hintStyle: TextStyle(
      color: Colors.black26,
      fontSize: 50),
    labelStyle: TextStyle(color: Colors.black87),
    enabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
    focusedBorder: 
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple[400])),
    );

// Get colors
final List colorsList = [
  Colors.red[700],
  Colors.pink[700],
  Colors.purple[700],
  Colors.deepPurple[700],
  Colors.indigo[700],
  Colors.blue[700],
  Colors.lightBlue[700],
  Colors.cyan[700],
  Colors.teal[700],
  Colors.green[700],
  Colors.lightGreen[700],
  Colors.lime[700],
  Colors.yellow[700],
  Colors.amber[700],
  Colors.deepOrange[700],
  Colors.brown[700],
  Colors.blueGrey[600],
  Colors.grey[700]
  ];

  getColor(int colorIndex){
    return colorsList[colorIndex];
  }
