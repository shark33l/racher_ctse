import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherService {
  final String uid;
  TeacherService({this.uid});

  // collection reference
  final CollectionReference teacherCollection =
      Firestore.instance.collection('teachers');

  Future updateUserData(
      String firstName, String lastName, String displayPicture) async {
    return await teacherCollection.document(uid).setData({
      'firstName': firstName,
      'lastName': lastName,
      'displayPicture': displayPicture
    });
  }

  searchByName(String searchField) {
    return teacherCollection
        .where('searchKey',
            isEqualTo: searchField.substring(0, 1).toUpperCase())
        .getDocuments();
  }

  // Get User
}
