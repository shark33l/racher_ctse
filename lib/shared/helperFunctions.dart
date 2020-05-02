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
}