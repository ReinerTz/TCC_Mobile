// To parse this JSON data, do
//
//     final expenseModel = expenseModelFromMap(jsonString);

import 'dart:convert';

import 'package:tcc_project/models/group_model.dart';

class ExpenseModel {
  ExpenseModel({
    this.id,
    this.title,
    this.price,
    this.quantity,
    this.group,
  });

  int id;
  String title;
  double price;
  int quantity;
  GroupModel group;

  factory ExpenseModel.fromJson(String str) =>
      ExpenseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ExpenseModel.fromMap(Map<String, dynamic> json) => ExpenseModel(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        price: json["price"] == null ? null : json["price"],
        quantity: json["quantity"] == null ? null : json["quantity"],
        group: json["group"] == null ? null : GroupModel.fromMap(json["group"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "price": price == null ? null : price,
        "quantity": quantity == null ? null : quantity,
        "group": group == null ? null : group.toMap(),
      };
}
