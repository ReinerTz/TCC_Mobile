import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:tcc_project/models/user_model.dart';
import 'package:tcc_project/services/user_service.dart';

class ProfileController extends GetxController {
  RxString avatar = "".obs;
  RxBool isLoading = false.obs;

  UserModel user;
  ProfileController({Map pageArgs}) {
    if (pageArgs != null) {
      this.user = pageArgs["user"];
    }

    if (this.user != null) {
      this.avatar.value = this.user.avatar;
    }
  }

  Future updateProfileImage(File image) async {
    this.isLoading.value = true;
    StorageTaskSnapshot snapshot = await FirebaseStorage.instance
        .ref()
        .child("images/${this.user.uid}")
        .putFile(image)
        .onComplete;

    this.user.avatar = await snapshot.ref.getDownloadURL();
    UserService us = UserService();
    var response = await us.saveUser(this.user.toMap());
    this.avatar.value = response.data["avatar"];

    if ((snapshot.error == null) && (response.data != null)) {
      Get.defaultDialog(
        title: "Sucesso",
        middleText: "Foto adicionada com sucesso!",
        onConfirm: () => Get.back(),
      );
    } else {
      Get.defaultDialog(
        title: "Erro",
        middleText: "Ocorreu um erro ao adicionar a foto",
        onConfirm: () => print("dont work"),
      );
    }
    this.isLoading.value = false;
  }
}
