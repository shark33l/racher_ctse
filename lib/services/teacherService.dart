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
        .where('name',
            isEqualTo: searchField)
        .getDocuments();
  }

  getAllTeachers() {
    return teacherCollection.getDocuments();
  }

  Stream<QuerySnapshot> get allTeachers{
    return teacherCollection.snapshots();
  }

  Future addTeacherData(String name, String description, List subjects, List institutes, String currentInstitute, List academicInitials, String displayPicture) async {
    return await teacherCollection.add(
      {
        "name" : name,
        "description" : description,
        "subjects" : subjects,
        "institutes" : institutes,
        "currentInstitute" : currentInstitute,
        "academicInitials" : academicInitials,
        "rating": 0,
        "displayPicture": displayPicture
      }
    );
  }

  // Get User
}
