// To parse this JSON data, do
//
//     final userGroupModel = userGroupModelFromMap(jsonString);

import 'dart:convert';

import 'package:tcc_project/models/group_model.dart';
import 'package:tcc_project/models/user_model.dart';

class UserGroupModel {
  UserGroupModel({
    this.id,
    this.user,
    this.group,
    this.admin,
    this.receptor,
  });

  int id;
  UserModel user;
  GroupModel group;
  bool admin;
  bool receptor;

  factory UserGroupModel.fromJson(String str) =>
      UserGroupModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserGroupModel.fromMap(Map<String, dynamic> json) => UserGroupModel(
        id: json["id"] == null ? null : json["id"],
        user: json["user"] == null ? null : UserModel.fromMap(json["user"]),
        group: json["group"] == null ? null : GroupModel.fromMap(json["group"]),
        admin: json["admin"] == null ? null : json["admin"],
        receptor: json["receptor"] == null ? null : json["receptor"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "user": user == null ? null : user.toMap(),
        "group": group == null ? null : group.toMap(),
        "admin": admin == null ? null : admin,
        "receptor": receptor == null ? null : receptor,
      };
}
