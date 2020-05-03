import 'package:flutter/material.dart';

class Style {
  static final baseTextStyle = const TextStyle(
    fontFamily: 'Poppins'
  );
  static final smallTextStyle = commonTextStyle.copyWith(
    fontSize: 10.0,
    color: Colors.black38
  );
  static final smallTextBoldStyle = commonTextStyle.copyWith(
    fontSize: 10.0,
    color: Colors.black38,
    fontWeight: FontWeight.bold
  );
  static final commonTextStyle = baseTextStyle.copyWith(
      color: Colors.black54,
    fontSize: 14.0,
      fontWeight: FontWeight.w400
  );
  static final titleTextStyle = baseTextStyle.copyWith(
    color: Colors.black,
    fontSize: 18.0,
    fontWeight: FontWeight.w600
  );
  static final headerTextStyle = baseTextStyle.copyWith(
    color: Colors.black,
    fontSize: 20.0,
    fontWeight: FontWeight.w400
  );
}