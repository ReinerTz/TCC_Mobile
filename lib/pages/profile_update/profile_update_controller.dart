import 'package:get/get.dart';
import 'package:tcc_project/models/user_model.dart';
import 'package:tcc_project/services/user_service.dart';

class ProfileUpdateController extends GetxController {
  UserModel user;
  RxString field = "".obs;
  RxString value = "".obs;
  RxString fieldName = "".obs;
  RxBool loading = false.obs;

  ProfileUpdateController({Map pageArgs}) {
    if (pageArgs != null) {
      this.user = pageArgs["user"];
      this.field.value = pageArgs["params"]["field"];
      this.value.value = pageArgs["params"]["value"];
      this.fieldName.value = pageArgs["params"]["fieldName"];
    }
  }

  void setValue(String value) => this.value.value = value;

  Future<bool> save() async {
    this.loading.value = true;
    var user = this.user.toMap();
    user[this.fieldName.value] = this.value.value;
    UserService us = UserService();
    var response = await us.saveUser(user);
    this.loading.value = false;
    if (response.data != null) {
      this.user = UserModel.fromMap(user);
      Get.snackbar("Sucesso", "Registro salvo com sucesso.");
      return true;
    } else {
      Get.snackbar("Erro", "Ocorreu um erro ao salvar o registro.");
      return true;
    }
  }
}
