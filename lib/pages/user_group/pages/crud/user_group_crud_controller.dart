import 'dart:convert';

import 'package:get/get.dart';
import 'package:tcc_project/models/expense_model.dart';
import 'package:tcc_project/models/group_model.dart';
import 'package:tcc_project/models/user_model.dart';
import 'package:tcc_project/services/expense_service.dart';
import 'package:tcc_project/services/group_service.dart';
import 'package:uuid/uuid.dart';

enum DivisionOption { fixed, percentage, expense }

class UserGroupCrudController extends GetxController {
  UserModel user;
  GroupService _service = GroupService();
  ExpenseService _expenseService = ExpenseService();
  RxList<dynamic> peoples = <dynamic>[].obs;
  RxList<dynamic> expenses = <dynamic>[].obs;

  Rx<DivisionOption> division = DivisionOption.fixed.obs;

  UserGroupCrudController({Map pageArgs}) {
    this.user = pageArgs["user"];
  }

  void setDivision(DivisionOption value) => this.division.value = value;

  void generateList(int qtd) {
    this.peoples.clear();
    this.peoples.value = List.generate(qtd, (index) => index + 1);
  }

  void addPeople() {
    this.peoples.add(
          UserModel(name: "Pessoa ${this.peoples.length + 1}"),
        );
  }

  void addExpense({String title, double price, int quantity}) {
    this.expenses.add(
          ExpenseModel(price: price, title: title, quantity: quantity),
        );
  }

  Future<bool> saveGroup(String title, String description) async {
    GroupModel group = GroupModel();
    group.description = description;
    group.sharedKey = Uuid().v1();
    group.title = title;
    group.size = this.peoples.length;
    try {
      group.users = UserModel.fromJsonList(
        this.peoples.where((data) {
          return data.uid != null;
        }).toList(),
      );
    } catch (e) {
      print(e);
    }

    var result = await _service.saveGroup(group.toMap());

    await saveExpenses(GroupModel.fromJson(json.decode(result.data)));

    // group.sharedKey = Uuid;
    //_service.saveGroup(params);
  }

  Future<bool> saveExpenses(GroupModel group) {
    this.expenses.forEach((data) {
      ExpenseModel expenseModel = ExpenseModel();
      expenseModel.price = data.price;
      expenseModel.quantity = data.quantity;
      expenseModel.title = data.title;
      expenseModel.group = group;
      _expenseService.saveExpense(expenseModel.toMap());
    });
  }
}
