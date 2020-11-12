import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tcc_project/models/user_model.dart';
import 'package:tcc_project/routes/app_routes.dart';
import 'package:tcc_project/services/user_service.dart';
import 'package:tcc_project/utils/util.dart';

class ProfileUpdateController extends GetxController {
  UserModel user;
  RxString field = "".obs;
  RxString value = "".obs;
  RxString fieldName = "".obs;
  RxBool loading = false.obs;
  List<dynamic> userExpenses;
  bool initializing = false;
  final df = DateFormat("dd/MM/yyyy");

  ProfileUpdateController({Map pageArgs}) {
    if (pageArgs != null) {
      this.user = UserModel.fromMap(pageArgs["user"]);
      this.field.value = pageArgs["params"]["field"];
      this.value.value = pageArgs["params"]["value"];
      this.fieldName.value = pageArgs["params"]["fieldName"];
      this.userExpenses = pageArgs["userexpenses"];
      this.initializing = pageArgs["initializing"];

      assert(this.initializing != null);
    }
  }

  DateTime get valueAsDate => this.value.value != null &&
          this.fieldName.value == "birthday"
      ? DateTime.tryParse(
          "${this.value.value.substring(6, 10)}-${this.value.value.substring(3, 5)}-${this.value.value.substring(0, 2)}")
      : DateTime.now();

  void setValueDateTime(DateTime date) => this.value.value = df.format(date);

  void setValue(dynamic value) {
    if (value is DateTime) {
      this.setValueDateTime(value);
    } else {
      this.value.value = value;
    }
  }

  Future<bool> validate(String value) async {
    this.loading.value = true;
    try {
      bool valid = true;
      switch (this.fieldName.value) {
        case "birthday":
          bool valid = valueAsDate != null;
          if (!valid) {
            Get.defaultDialog(
              title: "Aviso",
              middleText: "Selecione uma data de nascimento",
              confirm: MaterialButton(
                onPressed: () => Get.back(),
                child: Text("Ok"),
                color: Get.theme.primaryColor,
              ),
            );
          }
          return valid;
        case "exclusive_user_name":
          valid =
              (value.length > 3) && (value[0] == "@") && (!value.contains(" "));
          if (!valid) {
            Get.defaultDialog(
              title: "Aviso",
              middleText:
                  "O seu nome exclusivo deve conter mais de 3 caracteres, não pode conter espaços e deve começar com '@'",
              confirm: MaterialButton(
                onPressed: () => Get.back(),
                child: Text("Ok"),
                color: Get.theme.primaryColor,
              ),
            );
            return valid;
          }
          UserService service = UserService();
          Response response =
              await service.getOneUserByExclusiveUserName(value);
          if (response.statusCode == 200) {
            if ((response.data == null) || (response.data["uid"] == user.uid)) {
              return true;
            } else {
              Get.defaultDialog(
                title: "Aviso",
                middleText: "Este nome já existe, tente outro nome.",
                confirm: MaterialButton(
                  onPressed: () => Get.back(),
                  child: Text("Ok"),
                  color: Get.theme.primaryColor,
                ),
              );
              return false;
            }
          }

          Get.defaultDialog(
            title: "Aviso",
            middleText:
                "Ocorreu um erro de conexão, tente novamente mais tarde",
            confirm: MaterialButton(
              onPressed: () => Get.back(),
              child: Text("Ok"),
              color: Get.theme.primaryColor,
            ),
          );

          return false;
        case "name":
          valid = value.length > 2;
          if (!valid) {
            Get.defaultDialog(
              title: "Aviso",
              middleText: "Por favor, informe pelomenos 2 caracteres",
              confirm: MaterialButton(
                onPressed: () => Get.back(),
                child: Text("Ok"),
                color: Get.theme.primaryColor,
              ),
            );
          }
          return valid;

        default:
          return true;
      }
    } finally {
      this.loading.value = false;
    }
  }

  Future save() async {
    if (!await validate(this.value.value)) {
      return;
    }
    this.loading.value = true;

    try {
      var user = this.user.toMap();
      if (this.fieldName.value == "birthday") {
        UserModel userModel = UserModel.fromMap(user);
        userModel.birthday = this.valueAsDate;
        user = userModel.toMap();
      } else {
        user[this.fieldName.value] = this.value.value;
      }
      UserService us = UserService();
      var response = await us.saveUser(user);
      if (response.data != null) {
        this.user = UserModel.fromMap(user);
        Get.snackbar("Sucesso", "Registro salvo com sucesso.");
      } else {
        Get.snackbar("Erro", "Ocorreu um erro ao salvar o registro.");
      }
    } finally {
      this.loading.value = false;
      if (this.initializing) {
        Map<String, dynamic> item = Util.finishRegister(this.user.toMap());
        if (item != null) {
          Get.offAllNamed(Routes.PROFILE_UPDATE, arguments: {
            "user": this.user.toMap(),
            "userexpenses": this.userExpenses,
            "initializing": true,
            "params": item,
          });
        } else {
          Get.offAllNamed(Routes.HOME, arguments: {
            "user": this.user.toMap(),
            "userexpenses": this.userExpenses
          });
        }
      } else {
        Get.offAllNamed(Routes.PROFILE, arguments: {
          "user": this.user.toMap(),
          "userexpenses": this.userExpenses
        });
      }
    }
  }
}
