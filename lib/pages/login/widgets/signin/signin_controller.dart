import 'package:get/get.dart';

class SignInController extends GetxController {
  SignInController() {
    this.email = "".obs;
    this.password = "".obs;
  }

  RxString email;
  RxString password;

  setEmail(String value) => this.email.value = value;
  setPassword(String value) => this.password.value = value;

  signIn() {
    
  }
}
