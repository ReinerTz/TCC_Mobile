import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
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

    // TaskSnapshot snapshot = FirebaseStorage.instance
    //     .ref()
    //     .child("images/${this.user.uid}")
    //     .putFile(image)
    //     .snapshot;

    await FirebaseStorage.instance
        .ref()
        .child("images/${this.user.uid}")
        .putFile(image)
        .then((data) async {
      await data.ref.getDownloadURL().then((value) {
        this.user.avatar = value;
      });
    });

    this.user.avatar =
        await Util.uploadImageFirebase(image, "images/${this.user.uid}");

    //await task.whenComplete(() => null);
    // this.user.avatar = await task.storage.ref().getDownloadURL();

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
