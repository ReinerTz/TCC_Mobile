import 'package:get/get.dart';
import 'package:tcc_project/models/user_model.dart';
import 'package:tcc_project/services/sign_up_service.dart';

class SignUpController extends GetxController {
  SignUpController() {
    this.email = "".obs;
    this.password = "".obs;
    this.name = "".obs;
    this.loading = false.obs;
  }

  RxString name;
  RxString email;
  RxString password;
  RxBool loading;

  setEmail(String value) => this.email.value = value;
  setPassword(String value) => this.password.value = value;
  setName(String value) => this.name.value = value;
  setLoading(bool value) => this.loading.value = value;

  bool get isValid =>
      (this.password.value.length >= 6) &&
      (GetUtils.isEmail(this.email.value)) &&
      // (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      //     .hasMatch(this.email.value)) &&
      (this.name.value.length >= 3);

  Future<bool> signUp() async {
    SignUpService sus = SignUpService();
    return await sus.signUp(
        UserModel(
          email: this.email.value,
          name: this.name.value,
        ),
        this.password.value);
  }
}
