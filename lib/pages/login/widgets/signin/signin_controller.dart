import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcc_project/services/sign_in_service.dart';

class SignInController extends GetxController {
  SignInController() {
    this.email = "".obs;
    this.password = "".obs;
    this.loading = false.obs;
  }

  RxString email;
  RxString password;
  RxBool loading;

  setEmail(String value) => this.email.value = value;
  setPassword(String value) => this.password.value = value;
  setLoading(bool value) => this.loading.value = value;

  bool get isValid =>
      (this.password.value.length >= 6) && GetUtils.isEmail(this.email.value);

  Future<void> signIn() async {
    SignInService sis = SignInService();
    return await sis.signInFirebase(this.email.value, this.password.value);
  }

  Future<void> forgotPassword() async {
    if (!GetUtils.isEmail(this.email.value)) {
      Get.defaultDialog(
        title: "Aviso",
        middleText:
            "Informe um e-mail válido no campo de e-mail para poder redefinir sua senha",
        confirm: MaterialButton(
          onPressed: () => Get.back(),
          child: Text("Ok"),
          color: Get.theme.primaryColor,
        ),
      );
    } else {
      var response = await SignInService().recoverPassword(this.email.value);
      if (response) {
        Get.defaultDialog(
          title: "Informação",
          middleText:
              "Enviamos um e-mail de recuperação de senha para ${this.email.value}",
          confirm: MaterialButton(
            onPressed: () => Get.back(),
            child: Text("Ok"),
            color: Get.theme.primaryColor,
          ),
        );
      }
    }
  }
}
