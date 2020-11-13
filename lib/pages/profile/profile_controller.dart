import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcc_project/models/user_model.dart';
import 'package:tcc_project/services/user_service.dart';
import 'package:tcc_project/utils/util.dart';

class ProfileController extends GetxController {
  RxString avatar = "".obs;
  RxBool isLoading = false.obs;
  List<dynamic> userExpenses;

  UserModel user;
  ProfileController({Map pageArgs}) {
    if (pageArgs != null) {
      this.user = UserModel.fromMap(pageArgs["user"]);
      this.userExpenses = pageArgs["userexpenses"];
    }

    if (this.user != null) {
      this.avatar.value = this.user.avatar;
    }
  }

  Future updateProfileImage(File image) async {
    this.isLoading.value = true;

    this.user.avatar =
        await Util.uploadImageFirebase(image, "images/${this.user.uid}");

    UserService us = UserService();
    var response = await us.saveUser(this.user.toMap());
    this.avatar.value = response.data["avatar"];

    if (response.data != null) {
      Get.defaultDialog(
        title: "Sucesso",
        middleText: "Foto adicionada com sucesso!",
        confirm: MaterialButton(
          onPressed: () => Get.back(),
          child: Text("Ok"),
          color: Get.theme.primaryColor,
        ),
      );
    } else {
      Get.defaultDialog(
        title: "Erro",
        middleText: "Ocorreu um erro ao adicionar a foto",
        confirm: MaterialButton(
          onPressed: () => Get.back,
          child: Text("Ok"),
          color: Get.theme.primaryColor,
        ),
      );
    }
    this.isLoading.value = false;
  }
}
