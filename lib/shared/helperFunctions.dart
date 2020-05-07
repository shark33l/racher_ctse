import 'package:intl/intl.dart';

class HelperFunctions {

// Get List as string
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

  // Get Date difference or date
  String getDateDiffOrDate(DateTime earlier, DateTime later){

    Duration duration = later.difference(earlier);
    String returnDate;

    if(duration.inSeconds > 604800){
      returnDate = DateFormat.yMMMMd('en_US').add_jm().parse(earlier.toString()).toString();
    } else if (duration.inDays >= 1){
      returnDate = duration.inDays.toString() + 'd ';
      if(checkTimeValue(duration.inHours, 24) > 0){
        returnDate = returnDate + checkTimeValue(duration.inHours, 24).toString() + 'h';
      }
      returnDate = returnDate + ' ago';
    } else if (checkTimeValue(duration.inHours, 24) >= 1){
      returnDate = checkTimeValue(duration.inHours, 24).toString() + 'h ';
      if(checkTimeValue(duration.inMinutes, 60) >= 1){
        returnDate = returnDate + checkTimeValue(duration.inMinutes, 60).toString() + 'm';
      }
      returnDate = returnDate + ' ago';
    } else if (checkTimeValue(duration.inMinutes, 60) >= 1){
      returnDate = checkTimeValue(duration.inMinutes, 60).toString() + 'm ';
      if(checkTimeValue(duration.inSeconds, 60) >= 1){
        returnDate = returnDate = checkTimeValue(duration.inSeconds, 60).toString() + 's';
      }
      returnDate = returnDate + ' ago';
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