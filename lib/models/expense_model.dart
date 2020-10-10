// To parse this JSON data, do
//
//     final expenseModel = expenseModelFromMap(jsonString);

import 'dart:convert';

class ExpenseModel {
  ExpenseModel({
    this.id,
    this.title,
    this.price,
    this.quantity,
  });

  int id;
  String title;
  double price;
  int quantity;

  factory ExpenseModel.fromJson(String str) =>
      ExpenseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ExpenseModel.fromMap(Map<String, dynamic> json) => ExpenseModel(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        price: json["price"] == null ? null : json["price"],
        quantity: json["quantity"] == null ? null : json["quantity"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "price": price == null ? null : price,
        "quantity": quantity == null ? null : quantity,
      };
}
