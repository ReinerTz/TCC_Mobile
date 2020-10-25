import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:tcc_project/models/expense_model.dart';
import 'package:tcc_project/models/group_model.dart';
import 'package:tcc_project/models/user_model.dart';
import 'package:tcc_project/services/friendship_service.dart';
import 'package:tcc_project/services/group_service.dart';
import 'package:tcc_project/services/usergroup_service.dart';

enum Screen { peoples, expenses }

class UserGroupCrudController extends GetxController {
  UserModel user;
  Rx<GroupModel> group = GroupModel().obs;
  GroupService _service = GroupService();
  FriendShipService _serviceFS = FriendShipService();
  UserGroupService _serviceUG = UserGroupService();
  //ExpenseService _expenseService = ExpenseService();
  RxList<dynamic> peoples = <dynamic>[].obs;
  RxList<dynamic> expenses = <dynamic>[].obs;
  Rx<Screen> actualScreen = Screen.peoples.obs;
  RxBool isLoading = false.obs;
  RxString avatar = "".obs;
  bool isAdmin;

  UserGroupCrudController({Map pageArgs}) {
    this.user = UserModel.fromMap(pageArgs["user"]);
    this.group.value = GroupModel.fromMap(pageArgs["group"]);
    this.peoples.value = pageArgs["peoples"];
    this.expenses.value = pageArgs["expenses"];

    if (this.user != null) {
      this.avatar.value = this.group.value.avatar;
    }

    isAdmin = this
        .peoples
        .where((data) => ((data["user"] != null) &&
            (data["user"]["uid"] == user.uid) &&
            (data["admin"])))
        .toList()
        .isNotEmpty;
    print(isAdmin);
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

  Future getFriends() async {
    isLoading.value = true;
    var result;
    try {
      Response response = await _serviceFS.findById(user.uid);
      if (response.statusCode == 200) {
        result = List.from(
          response.data
                  ?.where((element) => element["status"] == 'ACCEPT')
                  ?.toList() ??
              List(),
        );
      }
    } finally {
      isLoading.value = false;
    }
    return result;
  }

  Future deleteUserGroup(dynamic user) async {
    Response result = await _serviceUG.deleteUserGroup(user);
    if (result.statusCode == 200) {
      this.peoples.remove(user);
    }
  }
}
