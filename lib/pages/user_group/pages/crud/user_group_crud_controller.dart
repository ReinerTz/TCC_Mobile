import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcc_project/models/expense_model.dart';
import 'package:tcc_project/models/group_model.dart';
import 'package:tcc_project/models/user_model.dart';
import 'package:tcc_project/models/userexpense_model.dart';
import 'package:tcc_project/models/usergroup_model.dart';
import 'package:tcc_project/pages/user_group/user_group_controller.dart';
import 'package:tcc_project/services/expense_service.dart';
import 'package:tcc_project/services/friendship_service.dart';
import 'package:tcc_project/services/group_service.dart';
import 'package:tcc_project/services/userexpense_service.dart';
import 'package:tcc_project/services/usergroup_service.dart';
import 'package:tcc_project/utils/util.dart';

enum Screen { peoples, expenses, chat }

class UserGroupCrudController extends GetxController {
  UserModel user;
  Rx<GroupModel> group = GroupModel().obs;

  GroupService _service = GroupService();
  FriendShipService _serviceFS = FriendShipService();
  UserGroupService _serviceUG = UserGroupService();
  UserExpenseService _serviceUE = UserExpenseService();
  ExpenseService _serviceEx = ExpenseService();

  Rx<File> paymentFile = File("").obs;
  RxString observation = "".obs;
  RxBool closed = false.obs;
  RxList<dynamic> peoples = <dynamic>[].obs;
  RxList<dynamic> expenses = <dynamic>[].obs;
  RxList<dynamic> userExpenses = <dynamic>[].obs;
  Rx<Screen> actualScreen = Screen.peoples.obs;
  RxBool isLoading = false.obs;
  RxString avatar = "".obs;
  // bool isAdmin;

  final ugc = Get.find<UserGroupController>();

  UserGroupCrudController({Map pageArgs}) {
    this.user = UserModel.fromMap(pageArgs["user"]);
    this.group.value = GroupModel.fromMap(pageArgs["group"]);
    this.peoples.value = pageArgs["peoples"];
    this.expenses.value = pageArgs["expenses"];
    this.userExpenses.value = pageArgs["userexpense"];

    if (this.user != null) {
      this.avatar.value = this.group.value.avatar;
    }

    this.observation.value = this.getActualUserGroup().paymentObservation;
  }

  bool get isAdmin => this
      .peoples
      .where((data) => ((data["user"] != null) &&
          (data["user"]["uid"] == user.uid) &&
          (data["admin"])))
      .toList()
      .isNotEmpty;

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

    this.group.value.avatar = await Util.uploadImageFirebase(
        image, "images/group/${this.group.value.id}");

    this.avatar.value = this.group.value.avatar;
    bool ok = await saveGroup();

    if (ok) {
      Get.defaultDialog(
        title: "Sucesso",
        middleText: "Foto adicionada com sucesso!",
        confirm: MaterialButton(
          color: Get.theme.primaryColor,
          child: Text("Ok"),
          onPressed: () => Get.back(),
        ),
      );
    } else {
      Get.defaultDialog(
        title: "Erro",
        middleText: "Ocorreu um erro ao adicionar a foto",
        confirm: MaterialButton(
          color: Get.theme.primaryColor,
          child: Text("Ok"),
          onPressed: () => Get.back(),
        ),
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

  Future deleteExpense(dynamic expense) async {
    Response result = await _serviceEx.delete(expense);
    if (result.statusCode == 200) {
      this.expenses.remove(expense);
    }
  }

  List createUserExpense() {
    List<Map<String, dynamic>> list = [];
    this.peoples.forEach((data) {
      list.add(
        UserExpenseModel(
                checked: true,
                percent: (1 / this.peoples.length) * 100,
                userGroup: UserGroupModel.fromMap(data))
            .toMap(),
      );
    });
    return list;
  }

  Future getUserExpense(dynamic expense) async {
    this.isLoading.value = true;
    try {
      var response = (await _serviceUE.findUserExpenses(expense["id"])).data;

      return response ?? createUserExpense();
    } finally {
      this.isLoading.value = false;
    }
  }

  double getTotalByPeople(int usergroup) {
    double value = 0;
    this
        .userExpenses
        .where((data) => data["userGroup"]["id"] == usergroup)
        .forEach((element) {
      value += element["price"];
    });
    return value;
  }

  double getTotalSplit() {
    double value = 0;
    this.userExpenses.forEach((element) {
      value += element["price"];
    });
    return value;
  }

  double getTotalExpenses() {
    double value = 0;
    this.expenses.forEach((element) {
      value += (element["price"] * element["quantity"]);
    });
    return value;
  }

  double getMyTotal() {
    double value = 0;
    this
        .userExpenses
        .where((data) =>
            (data["userGroup"]["user"] != null) &&
            (data["userGroup"]["user"]["uid"] == user.uid))
        .forEach((element) {
      value += element["price"];
    });
    return value;
  }

  List<dynamic> getMyExpenses() {
    return this
        .userExpenses
        .where((data) =>
            (data["userGroup"]["user"] != null) &&
            (data["userGroup"]["user"]["uid"] == user.uid))
        .toList();
  }

  Future closeExpenses() async {
    this.isLoading.value = true;
    try {
      this.group.value.closed = true;
      Response response = await _service.saveGroup(this.group.value.toMap());
      if (response.statusCode == 200) {
        await ugc.refreshData();
        this.group.value = GroupModel.fromMap(response.data);
        Get.defaultDialog(
          middleText: "Conta fechada com sucesso",
          title: "Informação",
          confirm: MaterialButton(
            color: Get.theme.primaryColor,
            child: Text("Ok"),
            onPressed: () => Get.back(),
          ),
        );
      }
    } finally {
      update();
      this.isLoading.value = false;
    }
  }

  UserGroupModel getActualUserGroup() {
    UserGroupModel usr = UserGroupModel.fromMap(
      this.peoples.firstWhere(
            (data) => (data["user"] != null &&
                (data["user"]["uid"] == this.user.uid)),
          ),
    );
    return usr;
  }

  int getUserGroupIndex() {
    for (int i = 0; i < this.peoples.length; i++) {
      if ((this.peoples[i]["user"] != null) &&
          (this.peoples[i]["user"]["uid"] == this.user.uid)) {
        return i;
      }
    }
    return 0;
  }

  void setFile(File file) => this.paymentFile.value = file;

  void setObservation(String value) => this.observation.value = value;

  Future confirmPayment() async {
    this.isLoading.value = true;
    try {
      Get.back();

      if (this.observation.value.replaceAll(" ", "").isEmpty ||
          (this.paymentFile.value.path.isEmpty)) {
        Get.defaultDialog(
            title: "Aviso",
            middleText:
                "Você deve informar uma observação ou adicionar um comprovante para confirmar o pagamento");
      } else {
        int index = getUserGroupIndex();
        this.peoples[index]["paymentPicture"] = await Util.uploadImageFirebase(
            this.paymentFile.value, "images/group/user/${this.user.uid}");
        this.peoples[index]["paymentObservation"] = this.observation.value;
        Response response = await _serviceUG.save(this.peoples[index]);
        if (response.statusCode == 200) {
          Get.defaultDialog(
              title: "Aviso",
              middleText:
                  "Pagamento confirmado com sucesso, aguarde a aprovação do administrador do grupo.",
              confirm: MaterialButton(
                color: Get.theme.primaryColor,
                child: Text("Ok"),
                onPressed: () => Get.back(),
              ));
        }
      }
    } finally {
      update();
      this.isLoading.value = false;
    }
  }

  Future setUserGroupAsPaid(dynamic data) async {
    this.isLoading.value = true;
    Get.back();
    try {
      data["paid"] = true;
      Response response = await _serviceUG.save(data);
      if (response.statusCode == 200) {
        this.group.value = GroupModel.fromMap(this.group.value.toMap());
        Get.defaultDialog(
          title: "Informação",
          middleText: "Conta paga com sucesso",
          confirm: MaterialButton(
            color: Get.theme.primaryColor,
            onPressed: () => Get.back(),
            child: Text("Ok"),
          ),
        );
      }
    } finally {
      this.isLoading.value = false;
    }
  }

  Future refreshData() async {
    this.isLoading.value = true;
    try {
      this.group.value = await _service.findById(this.group.value.id);
      Response response = await _serviceEx.getByGroup(this.group.value.id);
      if (response.statusCode == 200) {
        this.expenses.value = response.data ?? List();
        response = await _serviceUG.findAllUsersByGroup(this.group.value.id);
        if (response.statusCode == 200) {
          this.peoples.value = response.data;
          response = await _serviceUE.findExpensesbyGroup(this.group.value.id);
          this.userExpenses.value = response.data;
        }
      }
    } finally {
      this.isLoading.value = false;
    }
  }

  void sendMessage(String text) {
    if (text.isNotEmpty) {
      FirebaseFirestore.instance
          .collection("group")
          .firestore
          .collection("${this.group.value.id}")
          .add({"user": this.user.uid, "date": DateTime.now(), "text": text});
    }
  }

  Future<void> sendMessageImage(File file) async {
    String text = await Util.uploadImageFirebase(file,
        "images/group/${this.group.value.id}/chat/${DateTime.now().millisecondsSinceEpoch}");

    FirebaseFirestore.instance
        .collection("group")
        .firestore
        .collection("${this.group.value.id}")
        .add({
      "user": this.user.uid,
      "date": DateTime.now(),
      "text": null,
      "image": text
    });
  }
}
