import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';

class FirestoreUpload{

  final String userPath = "user/";
  final String teacherPath = "teacherPath/"; 
  Future uploadImageToFirestore(String type, String name, File picture) async {
    String path = "";
    var randomNumber = Random(30);

    if(type == "users"){
      path = userPath;
    } else if(type== "teachers"){
      path = teacherPath;
    }
    String fileName = name.replaceAll(" ", "") + randomNumber.nextInt(5000).toString() + ".jpg";
    String filePath = path + fileName;
    final StorageReference storageReference = FirebaseStorage.instance.ref().child(filePath);
    final task = storageReference.putFile(picture);
    await task.onComplete;
    return await storageReference.getDownloadURL();
  }

}