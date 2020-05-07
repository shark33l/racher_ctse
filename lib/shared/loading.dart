import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// Small Loading for buttons
class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpinKitThreeBounce(
          color: Colors.white,
          size: 10.0,
        );
  }
}

// Full Screen Loading
class LoadingFull extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpinKitThreeBounce(
          color: Colors.deepPurple[700],
          size: 50.0,
        );
  }
}

// Loader for Images
class ImageLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpinKitDoubleBounce(
      color: Colors.deepPurple[700],
      size: 50,
    );
  }
}