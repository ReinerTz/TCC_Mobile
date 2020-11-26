import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:tcc_project/models/user_model.dart';
import 'package:tcc_project/models/usergroup_model.dart';

class Util {
  static String onlyNumbers(String value) {
    String result = "";
    for (int i = 0; i < value.length; i++) {
      if (double.tryParse(value[i]) != null) {
        // verifica se é um número
        result += value[i];
      }
    }
    return result;
  }

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
    return await FirebaseStorage.instance
        .ref()
        .child(path)
        .putFile(image)
        .then((data) async {
      return await data.ref.getDownloadURL().then((value) {
        return value;
      });
    });

    // TaskSnapshot snapshot =
    //     FirebaseStorage.instance.ref().child(path).putFile(image).snapshot;

    // return await snapshot.ref.getDownloadURL();
  }

  static List<dynamic> items(UserModel user) {
    return [
      {
        "field": "Nome",
        "value": user.name,
        "fieldName": "name",
        "canChange": true,
        "required": true,
      },
      {
        "field": "Email",
        "value": user.email,
        "fieldName": "email",
        "canChange": false,
        "required": true,
      },
      {
        "field": "Data de nascimento",
        "value": user.birthday,
        "fieldName": "birthday",
        "canChange": false,
        "required": true,
      },
      {
        "field": "Telefone",
        "value": user.phone,
        "fieldName": "phone",
        "canChange": true,
        "required": false,
      },
      {
        "field": "Nome exclusivo",
        "value": user.exclusiveUserName,
        "fieldName": "exclusive_user_name",
        "canChange": true,
        "required": true,
      },
    ];
  }

  static Map<String, dynamic> finishRegister(dynamic user) {
    List<dynamic> lst = Util.items(UserModel.fromMap(user))
        .where((element) => element["required"])
        .toList();
    for (dynamic item in lst) {
      if ((item["value"] == null) || (item["value"] == "")) {
        return item;
      }
    }
    return null;
  }
}
