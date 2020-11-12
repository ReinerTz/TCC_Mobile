// To parse this JSON data, do
//
//     final userModel = userModelFromMap(jsonString);

import 'dart:convert';

import 'package:tcc_project/models/group_model.dart';

class UserModel {
  UserModel({
    this.name,
    this.email,
    this.birthday,
    this.avatar,
    this.exclusiveUserName,
    this.phone,
    this.groups,
    this.uid,
  });

  String name;
  String email;
  DateTime birthday;
  String avatar;
  String exclusiveUserName;
  String phone;
  List<GroupModel> groups;
  String uid;

  factory UserModel.fromJson(String str) => UserModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        name: json["name"] == null ? "" : json["name"],
        email: json["email"] == null ? "" : json["email"],
        birthday:
            json["birthday"] == null ? null : DateTime.parse(json["birthday"]),
        avatar: json["avatar"] == null ? "" : json["avatar"],
        exclusiveUserName: json["exclusive_user_name"] == null
            ? ""
            : json["exclusive_user_name"],
        phone: json["phone"] == null ? "" : json["phone"],
        uid: json["uid"] == null ? null : json["uid"],
      );

  Map<String, dynamic> toMap() => {
        "name": name == null ? "" : name,
        "email": email == null ? "" : email,
        "birthday": birthday == null
            ? null
            : "${birthday.year.toString().padLeft(4, '0')}-${birthday.month.toString().padLeft(2, '0')}-${birthday.day.toString().padLeft(2, '0')}",
        "avatar": avatar == null ? "" : avatar,
        "exclusive_user_name":
            exclusiveUserName == null ? "" : exclusiveUserName,
        "phone": phone == null ? "" : phone,
        "uid": uid == null ? "" : uid,
      };

  static List<UserModel> fromJsonList(List list) {
    if (list == null) return null;

    // list.forEach((element) {
    //   return UserModel.fromJson(element);
    // });
    // return list;

    return list.map<dynamic>((item) {
      return UserModel.fromJson(item);
    }).toList();
  }
}
