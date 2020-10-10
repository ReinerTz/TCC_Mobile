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
  List<int> birthday;
  dynamic avatar;
  String exclusiveUserName;
  String phone;
  List<GroupModel> groups;
  String uid;

  factory UserModel.fromJson(String str) => UserModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        name: json["name"] == null ? null : json["name"],
        email: json["email"] == null ? null : json["email"],
        birthday: json["birthday"] == null
            ? null
            : List<int>.from(json["birthday"].map((x) => x)),
        avatar: json["avatar"],
        exclusiveUserName: json["exclusive_user_name"] == null
            ? null
            : json["exclusive_user_name"],
        phone: json["phone"] == null ? null : json["phone"],
        groups: json["groups"] == null
            ? null
            : List<GroupModel>.from(
                json["groups"].map((x) => GroupModel.fromMap(x))),
        uid: json["uid"] == null ? null : json["uid"],
      );

  Map<String, dynamic> toMap() => {
        "name": name == null ? null : name,
        "email": email == null ? null : email,
        "birthday": birthday == null
            ? null
            : List<dynamic>.from(birthday.map((x) => x)),
        "avatar": avatar,
        "exclusive_user_name":
            exclusiveUserName == null ? null : exclusiveUserName,
        "phone": phone == null ? null : phone,
        "groups": groups == null
            ? null
            : List<dynamic>.from(groups.map((x) => x.toMap())),
        "uid": uid == null ? null : uid,
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
