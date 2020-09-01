import 'package:get/get.dart';
import 'package:tcc_project/models/user_model.dart';
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
  // (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
  //     .hasMatch(this.email.value));

  Future<UserModel> signIn() async {
    SignInService sis = SignInService();
    return await sis.signIn(this.email.value, this.password.value);
  }
}
