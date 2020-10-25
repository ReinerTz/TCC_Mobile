import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tcc_project/models/user_model.dart';
import 'package:tcc_project/routes/app_routes.dart';
import 'package:tcc_project/services/sign_in_service.dart';

enum Status { NONE, NOTLOGGED }

class LoginController extends GetxController {
  LoginController() {
    firstScreen.value = true;
  }

  @override
  void onInit() {
    FirebaseAuth.instance.onAuthStateChanged.listen((user) async {
      this.loading.value = true;
      update();
      if (user != null) {
        if (user.uid.isNotEmpty) {
          var response = await sis.signInWithUid(user.uid);
          Get.offAllNamed(Routes.HOME,
              arguments: {"user": UserModel.fromMap(response.data)});
        }
      }
      this.loading.value = false;
    });
  }

  RxBool loading = false.obs;
  RxBool firstScreen = true.obs;
  Rx<Status> status = Status.NONE.obs;
  SignInService sis = SignInService();

  void setFirstScreen(bool value) => this.firstScreen.value = value;
}
