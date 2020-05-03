import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HelperFunctions {

  String commaSeperatedStringFromList (List list){
    String listString = '';
    for(int i = 0; i < list.length; i++){
      String seperator = '';
      if(i != 0){
        seperator = ", ";
      }
      listString = listString + seperator + list[i];
    }

    return listString;
  }

  // Wrapped Chips
  Widget generateChips(List list, Color backgroundColor, Color textColor){
    if(list.length > 0){

      List<Widget> chipList = List<Widget>.from(list
            .map((tag) => Chip(
                  label: Text(
                    tag,
                    style: TextStyle(color: textColor),
                  ),
                  backgroundColor: backgroundColor, 
                ))
            .toList());

      return SizedBox(
        width: double.infinity,
        child: Wrap(
          spacing: 4,
          runSpacing: -8,
          direction: Axis.horizontal,
          alignment: WrapAlignment.start,
          children: chipList
        ),
      );
    } else {
      return Container(
        height: 0,
        width: 0
      );
    }
  }

  // Get Date difference or date
  String getDateDiffOrDate(DateTime earlier, DateTime later){

    Duration duration = later.difference(earlier);
    String returnDate;

    if(duration.inSeconds > 604800){
      returnDate = DateFormat.yMMMMd('en_US').add_jm().parse(earlier.toString()).toString();
    } else if (duration.inDays >= 1){
      returnDate = duration.inDays.toString() + 'd ';
      if(duration.inHours > 0){
        returnDate = returnDate + checkTimeValue(duration.inHours, 24).toString() + 'h ago';
      }
    } else if (duration.inHours >= 1){
      returnDate = checkTimeValue(duration.inHours, 24).toString() + 'h ';
      if(duration.inMinutes >= 1){
        returnDate = returnDate + checkTimeValue(duration.inMinutes, 60).toString() + 'm ago';
      }
    } else if (duration.inMinutes >= 1){
      returnDate = checkTimeValue(duration.inMinutes, 60).toString() + 'm ';
      if(duration.inSeconds >= 1){
        returnDate = returnDate = checkTimeValue(duration.inSeconds, 60).toString() + 's ago';
      }
    } else if (duration.inSeconds == 0){
      returnDate = "Just now";
    } else {
      returnDate = returnDate = duration.inSeconds.toString() + 's ago';
    }

    return returnDate;

  }

  int checkTimeValue(time, modulus){
    return time % modulus;
  }

}