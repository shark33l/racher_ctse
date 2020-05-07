import 'package:flutter/material.dart';

// Separator
class Separator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: new EdgeInsets.symmetric(vertical: 8.0),
        height: 1.0,
        width: double.infinity,
        color: Colors.black26
    );
  }
}

// Thin Neutral Separators
class CardSeparator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: new EdgeInsets.symmetric(vertical: 3.0),
        height: 1.0,
        width: double.infinity,
        color: Colors.black26
    );
  }
}