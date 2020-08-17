import 'package:get/get.dart';

class LoginController extends GetxController {
  LoginController() {    
    firstScreen.value = true;
  }
  RxBool firstScreen = true.obs;

  void setFirstScreen(bool value) => this.firstScreen.value = value;
}
