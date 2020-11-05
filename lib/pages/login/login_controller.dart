import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tcc_project/models/user_model.dart';
import 'package:tcc_project/routes/app_routes.dart';
import 'package:tcc_project/services/sign_in_service.dart';
import 'package:tcc_project/services/user_service.dart';
import 'package:tcc_project/services/userexpense_service.dart';

enum Status { NONE, NOTLOGGED }

class LoginController extends GetxController {
  UserExpenseService _userExpenseService = UserExpenseService();
  RxBool loading = false.obs;
  RxBool firstScreen = true.obs;
  Rx<Status> status = Status.NONE.obs;
  SignInService sis = SignInService();
  UserService us = UserService();

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
          Response response = await sis.signInWithUid(user.uid);
          if (response.statusCode == 200) {
            if (response.data == null) {
              await FirebaseAuth.instance.signOut();
            } else {
              Response result =
                  await _userExpenseService.findExpensesbyUser(user.uid);
              Get.offAllNamed(Routes.HOME, arguments: {
                "user": response.data,
                "userexpenses": result.data
              });
            }
          }
        }
      }
      this.loading.value = false;
    });
  }

  void setFirstScreen(bool value) => this.firstScreen.value = value;
}
