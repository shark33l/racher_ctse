import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpinKitThreeBounce(
          color: Colors.white,
          size: 10.0,
        );
  }
}

class LoadingFull extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpinKitThreeBounce(
          color: Colors.deepPurple[700],
          size: 50.0,
        );
  }
}