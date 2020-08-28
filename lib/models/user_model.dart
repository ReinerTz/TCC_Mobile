// To parse this JSON data, do
//
//     final userModel = userModelFromMap(jsonString);

import 'dart:convert';

UserModel userModelFromMap(String str) => UserModel.fromMap(json.decode(str));

String userModelToMap(UserModel data) => json.encode(data.toMap());

class UserModel {
  UserModel({
    this.name,
    this.email,
    this.uid,
    this.avatar,
  });

  String name;
  String email;
  String uid;
  String avatar;

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        name: json["name"],
        email: json["email"],
        uid: json["uid"],
        avatar: json["avatar"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "email": email,
        "uid": uid,
        "avatar": avatar,
      };
}
