import 'dart:convert';

import 'package:tcc_project/models/group_model.dart';
import 'package:tcc_project/models/user_model.dart';

class UserGroupModel {
  UserGroupModel({
    this.id,
    this.user,
    this.group,
    this.name,
    this.paymentObservation,
    this.paymentPicture,
    this.paid,
    this.admin,
    this.receptor,
  });

  int id;
  UserModel user;
  GroupModel group;
  String name;
  String paymentObservation;
  String paymentPicture;
  bool paid;
  bool admin;
  bool receptor;

  factory UserGroupModel.fromJson(String str) =>
      UserGroupModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserGroupModel.fromMap(Map<String, dynamic> json) => UserGroupModel(
        id: json["id"] == null ? null : json["id"],
        user: json["user"] == null ? null : UserModel.fromMap(json["user"]),
        group: json["group"] == null ? null : GroupModel.fromMap(json["group"]),
        name: json["name"] == null ? null : json["name"],
        paymentObservation: json["paymentObservation"] == null
            ? null
            : json["paymentObservation"],
        paymentPicture:
            json["paymentPicture"] == null ? null : json["paymentPicture"],
        paid: json["paid"] == null ? null : json["paid"],
        admin: json["admin"] == null ? null : json["admin"],
        receptor: json["receptor"] == null ? null : json["receptor"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "user": user == null ? null : user.toMap(),
        "group": group == null ? null : group.toMap(),
        "name": name == null ? null : name,
        "paymentObservation":
            paymentObservation == null ? null : paymentObservation,
        "paymentPicture": paymentPicture == null ? null : paymentPicture,
        "paid": paid == null ? null : paid,
        "admin": admin == null ? null : admin,
        "receptor": receptor == null ? null : receptor,
      };
}
