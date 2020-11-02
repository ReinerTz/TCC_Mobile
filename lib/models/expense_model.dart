// To parse this JSON data, do
//
//     final expenseModel = expenseModelFromMap(jsonString);

import 'dart:convert';

import 'package:tcc_project/models/group_model.dart';
import 'package:tcc_project/models/user_model.dart';

class ExpenseModel {
  ExpenseModel({
    this.id,
    this.title,
    this.price,
    this.quantity,
    this.date,
    this.createdBy,
    this.group,
  });

  int id;
  dynamic title;
  double price;
  int quantity;
  DateTime date;
  UserModel createdBy;
  GroupModel group;

  factory ExpenseModel.fromJson(String str) =>
      ExpenseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ExpenseModel.fromMap(Map<String, dynamic> json) => ExpenseModel(
        id: json["id"] == null ? null : json["id"],
        title: json["title"],
        price: json["price"] == null ? null : json["price"],
        quantity: json["quantity"] == null ? null : json["quantity"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        createdBy: json["createdBy"] == null
            ? null
            : UserModel.fromMap(json["createdBy"]),
        group: json["group"] == null ? null : GroupModel.fromMap(json["group"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "title": title,
        "price": price == null ? null : price,
        "quantity": quantity == null ? null : quantity,
        "date": date == null
            ? null
            : "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "createdBy": createdBy == null ? null : createdBy.toMap(),
        "group": group == null ? null : group.toMap(),
      };
}
