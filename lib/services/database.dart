import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:racher/models/user.dart';

class DatabaseService {

  final String uid;
  Random random = new Random();
  DatabaseService({ this.uid });

  // collection reference
  final CollectionReference userCollection = Firestore.instance.collection('users');

  // UserData from snapshot

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData(
      uid: uid,
      firstName: snapshot.data['firstName'],
      lastName: snapshot.data['lastName'],
      displayPicture: snapshot.data['displayPicture'],
      firstVisit: snapshot.data['firstVisit'],
      color: snapshot.data['color']
    );
  }

  // Create or Update User Data
  Future updateUserData(String firstName, String lastName, String displayPicture, bool firstVisit) async {

    return await userCollection.document(uid).setData({
      'firstName' : firstName,
      'lastName' : lastName,
      'displayPicture' : displayPicture,
      'firstVisit' : firstVisit,
      "color": random.nextInt(17)
    });
  }

  // Get User
  getuserById(String uid){
    return userCollection.document(uid).get();
  }

  // Get user doc stream
  Stream<UserData> get userData {
    return userCollection.document(uid).snapshots()
    .map(_userDataFromSnapshot);
  }
}