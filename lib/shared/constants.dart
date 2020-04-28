import 'package:flutter/material.dart';

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
