// To parse this JSON data, do
//
//     final userModel = userModelFromMap(jsonString);

import 'dart:convert';

class UserModel {
  UserModel({
    this.name,
    this.email,
    this.birthday,
    this.avatar,
    this.exclusiveUserName,
    this.phone,
    this.uid,
  });

  String name;
  String email;
  DateTime birthday;
  String avatar;
  String exclusiveUserName;
  String phone;
  String uid;

  factory UserModel.fromJson(String str) => UserModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        name: json["name"] == null ? null : json["name"],
        email: json["email"] == null ? null : json["email"],
        birthday:
            json["birthday"] == null ? null : DateTime.parse(json["birthday"]),
        avatar: json["avatar"] == null ? null : json["avatar"],
        exclusiveUserName: json["exclusive_user_name"] == null
            ? null
            : json["exclusive_user_name"],
        phone: json["phone"] == null ? null : json["phone"],
        uid: json["uid"] == null ? null : json["uid"],
      );

  Map<String, dynamic> toMap() => {
        "name": name == null ? null : name,
        "email": email == null ? null : email,
        "birthday": birthday == null
            ? null
            : "${birthday.year.toString().padLeft(4, '0')}-${birthday.month.toString().padLeft(2, '0')}-${birthday.day.toString().padLeft(2, '0')}",
        "avatar": avatar == null ? null : avatar,
        "exclusive_user_name":
            exclusiveUserName == null ? null : exclusiveUserName,
        "phone": phone == null ? null : phone,
        "uid": uid == null ? null : uid,
      };
}
