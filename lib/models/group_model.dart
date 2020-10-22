// To parse this JSON data, do
//
//     final groupModel = groupModelFromMap(jsonString);

import 'dart:convert';

class GroupModel {
  GroupModel({
    this.id,
    this.title,
    this.avatar,
    this.description,
    this.sharedKey,
    this.createdAt,
  });

  int id;
  String title;
  dynamic avatar;
  String description;
  String sharedKey;
  DateTime createdAt;

  factory GroupModel.fromJson(String str) =>
      GroupModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GroupModel.fromMap(Map<String, dynamic> json) => GroupModel(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        avatar: json["avatar"],
        description: json["description"] == null ? null : json["description"],
        sharedKey: json["sharedKey"] == null ? null : json["sharedKey"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "avatar": avatar,
        "description": description == null ? null : description,
        "sharedKey": sharedKey == null ? null : sharedKey,
        "createdAt": createdAt == null
            ? null
            : "${createdAt.year.toString().padLeft(4, '0')}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}",
      };
}
