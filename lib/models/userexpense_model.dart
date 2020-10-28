// To parse this JSON data, do
//
//     final userExpenseModel = userExpenseModelFromMap(jsonString);

import 'dart:convert';

import 'package:tcc_project/models/expense_model.dart';
import 'package:tcc_project/models/usergroup_model.dart';

class UserExpenseModel {
  UserExpenseModel({
    this.id,
    this.userGroup,
    this.expense,
    this.checked,
    this.price,
    this.percent,
  });

  int id;
  UserGroupModel userGroup;
  ExpenseModel expense;
  bool checked;
  double price;
  double percent;

  factory UserExpenseModel.fromJson(String str) =>
      UserExpenseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserExpenseModel.fromMap(Map<String, dynamic> json) =>
      UserExpenseModel(
        id: json["id"] == null ? null : json["id"],
        userGroup: json["userGroup"] == null
            ? null
            : UserGroupModel.fromMap(json["userGroup"]),
        expense: json["expense"] == null
            ? null
            : ExpenseModel.fromMap(json["expense"]),
        checked: json["checked"] == null ? null : json["checked"],
        price: json["price"] == null ? null : json["price"].toDouble(),
        percent: json["percent"] == null ? null : json["percent"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "userGroup": userGroup == null ? null : userGroup.toMap(),
        "expense": expense == null ? null : expense.toMap(),
        "checked": checked == null ? null : checked,
        "price": price == null ? null : price,
        "percent": percent == null ? null : percent,
      };
}
