import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:racher/models/teacher.dart';

class TeacherService {
  Random random = new Random();
  final String teacherId;

  TeacherService({this.teacherId});

  // collection reference
  final CollectionReference teacherCollection =
      Firestore.instance.collection('teachers');


  searchByName(String searchField) {
    return teacherCollection
        .where('name',
            isEqualTo: searchField)
        .getDocuments();
  }

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
        rating: double.parse(doc.data["rating"].toStringAsFixed(2)),
        displayPicture: doc.data["displayPicture"],
        coverPicture: doc.data["coverPicture"] ?? null,
        color: doc.data["color"],
        ratedUserCount : doc.data["ratedUserCount"]
      ); 
    }).toList();
  }

  TeacherData _teacherDataFromSnapshot(DocumentSnapshot doc){
    return TeacherData(
        documentId: doc.documentID,
        name: doc.data["name"],
        description: doc.data["description"],
        subjects: doc.data["subjects"],
        institutes: doc.data["institutes"],
        currentInstitute: doc.data["currentInstitute"],
        academicInitials: doc.data["academicInitials"],
        rating: double.parse(doc.data["rating"].toStringAsFixed(2)),
        displayPicture: doc.data["displayPicture"],
        coverPicture: doc.data["coverPicture"] ?? null,
        color: doc.data["color"],
        ratedUserCount : doc.data["ratedUserCount"]
    ); 
  }

  // get All teachers
  Stream<List<TeacherData>> get allTeachers{
    return teacherCollection.snapshots()
    .map(_teacherListFromSnapshot);
  }
  // get Higher Rated teachers
  Stream<List<TeacherData>> get popularTeachers{
    return teacherCollection.where("rating",isGreaterThan: 0.0).orderBy("rating", descending: true).limit(10).snapshots()
    .map(_teacherListFromSnapshot);
  }

  // Get teacher by id
  Stream<TeacherData> get teacherById{
    return teacherCollection.document(teacherId).snapshots()
    .map(_teacherDataFromSnapshot);
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
        "color": random.nextInt(17),
        "ratedUserCount": 0
      }
    );
  }

  Future updateTeacherData(String teacherId, Object data) async {
    return await teacherCollection.document(teacherId).updateData(data);
  }
}
