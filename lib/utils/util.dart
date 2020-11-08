import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:tcc_project/models/usergroup_model.dart';

class Util {
  static String getUserGroupName(UserGroupModel userGroupModel) {
    if (userGroupModel.user != null) {
      return userGroupModel.user.name;
    } else {
      if ((userGroupModel.name == null) || (userGroupModel.name.isEmpty)) {
        return "Anônimo ${userGroupModel.id}";
      } else {
        return userGroupModel.name;
      }
    }
  }

  static Future<String> uploadImageFirebase(File image, String path) async {
    StorageTaskSnapshot snapshot = await FirebaseStorage.instance
        .ref()
        .child(path)
        .putFile(image)
        .onComplete;

    return await snapshot.ref.getDownloadURL();
  }
}
