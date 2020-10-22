import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:tcc_project/models/expense_model.dart';
import 'package:tcc_project/models/group_model.dart';
import 'package:tcc_project/models/user_model.dart';
import 'package:tcc_project/services/group_service.dart';

enum Screen { peoples, expenses }

class UserGroupCrudController extends GetxController {
  UserModel user;
  Rx<GroupModel> group = GroupModel().obs;
  GroupService _service = GroupService();
  //ExpenseService _expenseService = ExpenseService();
  RxList<dynamic> peoples = <dynamic>[].obs;
  RxList<dynamic> expenses = <dynamic>[].obs;
  Rx<Screen> actualScreen = Screen.peoples.obs;
  RxBool isLoading = false.obs;
  RxString avatar = "".obs;

  UserGroupCrudController({Map pageArgs}) {
    this.user = UserModel.fromMap(pageArgs["user"]);
    this.group.value = GroupModel.fromMap(pageArgs["group"]);
    this.peoples.value = pageArgs["peoples"];
    this.expenses.value = pageArgs["expenses"];

    if (this.user != null) {
      this.avatar.value = this.group.value.avatar;
    }
  }

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

  Future<bool> saveGroup() async {
    Response result = await _service.saveGroup(this.group.value.toMap());

    return result.statusCode == 200;
  }

  // Future<bool> saveExpenses(GroupModel group) async {
  //   bool success = true;
  //   this.expenses.forEach((data) async {
  //     ExpenseModel expenseModel = ExpenseModel();
  //     expenseModel.price = data.price;
  //     expenseModel.quantity = data.quantity;
  //     expenseModel.title = data.title;
  //     expenseModel.group = group;
  //     Response response =
  //         await _expenseService.saveExpense(expenseModel.toMap());
  //     return response.statusCode == 200;
  //   });
  //   return success;
  // }

  Future updateProfileImage(File image) async {
    this.isLoading.value = true;
    StorageTaskSnapshot snapshot = await FirebaseStorage.instance
        .ref()
        .child("images/group/${this.group.value.id}")
        .putFile(image)
        .onComplete;

    this.group.value.avatar = await snapshot.ref.getDownloadURL();

    this.avatar.value = this.group.value.avatar;
    bool ok = await saveGroup();

    if (ok) {
      Get.defaultDialog(
        title: "Sucesso",
        middleText: "Foto adicionada com sucesso!",
        onConfirm: () => Get.back(),
      );
    } else {
      Get.defaultDialog(
        title: "Erro",
        middleText: "Ocorreu um erro ao adicionar a foto",
        onConfirm: () => Get.back(),
      );
    }
    this.isLoading.value = false;
  }
}
