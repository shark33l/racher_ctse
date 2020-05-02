import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:racher/models/teacher.dart';

class TeacherService {
  final String uid;
  Random random = new Random();
  TeacherService({this.uid});

  // collection reference
  final CollectionReference teacherCollection =
      Firestore.instance.collection('teachers');

  // Future updateUserData(
  //     String firstName, String lastName, String displayPicture) async {
  //   return await teacherCollection.document(uid).setData({
  //     'firstName': firstName,
  //     'lastName': lastName,
  //     'displayPicture': displayPicture
  //   });
  // }

  searchByName(String searchField) {
    return teacherCollection
        .where('name',
            isEqualTo: searchField)
        .getDocuments();
  }

  // getAllTeachers() {
  //   return teacherCollection.getDocuments();
  // }

  List<TeacherData> _teacherListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return TeacherData(
        documentId: doc.documentID,
        name: doc.data["name"],
        description: doc.data["description"],
        subjects: doc.data["subjects"],
        institutes: doc.data["institutes"],
        currentInstitute: doc.data["currentInstitute"],
        academicInitials: doc.data["academicInitials"],
        rating: num.parse(doc.data["rating"].toStringAsFixed(2)),
        displayPicture: doc.data["displayPicture"],
        coverPicture: doc.data["coverPicture"] ?? null,
        color: doc.data["color"]
      ); 
    }).toList();
  }

  Stream<List<TeacherData>> get allTeachers{
    return teacherCollection.snapshots()
    .map(_teacherListFromSnapshot);
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
        "displayPicture": displayPicture,
        "coverPicture": null,
        "color": random.nextInt(17)
      }
    );
  }



  // Get User
}
