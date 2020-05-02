class User {

  final String uid;

  User({this.uid});
  
}

class UserData {

  final String uid;
  final String firstName;
  final String lastName;
  final String displayPicture;
  bool firstVisit;
  int color;

  UserData({
    this.uid,
    this.firstName,
    this.lastName,
    this.displayPicture,
    this.firstVisit,
    this.color
  });
  
}