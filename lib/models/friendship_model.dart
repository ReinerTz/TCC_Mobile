// To parse this JSON data, do
//
//     final friendShipModel = friendShipModelFromMap(jsonString);

import 'dart:convert';

import 'package:tcc_project/models/user_model.dart';

class FriendShipModel {
  FriendShipModel({
    this.id,
    this.user,
    this.friend,
    this.status,
  });

  int id;
  UserModel user;
  UserModel friend;
  String status;

  factory FriendShipModel.fromJson(String str) =>
      FriendShipModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FriendShipModel.fromMap(Map<String, dynamic> json) => FriendShipModel(
        id: json["id"] == null ? null : json["id"],
        user: json["user"] == null ? null : UserModel.fromMap(json["user"]),
        friend:
            json["friend"] == null ? null : UserModel.fromMap(json["friend"]),
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "user": user == null ? null : user.toMap(),
        "friend": friend == null ? null : friend.toMap(),
        "status": status == null ? null : status,
      };
}
