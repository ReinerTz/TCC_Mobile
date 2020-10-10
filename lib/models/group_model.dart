// To parse this JSON data, do
//
//     final groupModel = groupModelFromMap(jsonString);

import 'dart:convert';

import 'package:tcc_project/models/user_model.dart';

class GroupModel {
  GroupModel({
    this.id,
    this.title,
    this.description,
    this.sharedKey,
    this.createdAt,
    this.users,
  });

  int id;
  String title;
  String description;
  String sharedKey;
  DateTime createdAt;
  List<UserModel> users;

  factory GroupModel.fromJson(String str) =>
      GroupModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GroupModel.fromMap(Map<String, dynamic> json) => GroupModel(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        description: json["description"] == null ? null : json["description"],
        sharedKey: json["sharedKey"] == null ? null : json["sharedKey"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(
                "${json["createdAt"][0]}-${json["createdAt"][1]}-${json["created"][2]}}"),
        users: json["users"] == null
            ? null
            : List<UserModel>.from(
                json["users"].map((x) => UserModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "description": description == null ? null : description,
        "sharedKey": sharedKey == null ? null : sharedKey,
        "createdAt": createdAt == null ? null : createdAt,
        "users": users == null
            ? null
            : List<dynamic>.from(users.map((x) => x.toMap())),
      };
}
