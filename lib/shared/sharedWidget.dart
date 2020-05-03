import 'package:flutter/material.dart';
import 'package:racher/shared/constants.dart';
import 'package:racher/shared/loading.dart';


class SharedWidget {


  // Widget for avatar
  Widget getAvatar(objectUT, radius, fontSize, String type) {
    String userInitials;
    if(type == "teacher"){
      userInitials = objectUT.name.substring(0, 1).toUpperCase();
    } else {
      userInitials = objectUT.firstName.substring(0, 1).toUpperCase() +
              objectUT.lastName.substring(0, 1).toUpperCase();
    }
    if (objectUT.displayPicture == null) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: getColor(objectUT.color),
        child: Text(
          userInitials,
          style: TextStyle(fontSize: fontSize, color: Colors.white),
        ),
      );
    } else {
      return ClipOval(
          child: Image.network(
        objectUT.displayPicture,
        loadingBuilder: (context, child, progress){
          return progress == null
            ? child
            : SizedBox(
              height: radius * 2,
              width: radius * 2,
              child: ImageLoading()
            );
        },
        fit: BoxFit.cover,
        width: radius * 2.0,
        height: radius * 2.0,
      ));
    }
  }
}