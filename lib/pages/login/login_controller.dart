import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tcc_project/models/user_model.dart';
import 'package:tcc_project/routes/app_routes.dart';
import 'package:tcc_project/services/sign_in_service.dart';
import 'package:tcc_project/services/user_service.dart';
import 'package:tcc_project/services/userexpense_service.dart';
import 'package:tcc_project/utils/util.dart';

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
    super.onInit();
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      this.loading.value = true;
      update();
      if (user != null) {
        if (user.uid.isNotEmpty) {
          Response response = await sis.signInWithUid(user.uid);
          if ((response != null) && (response.statusCode == 200)) {
            dynamic userModel = response.data;
            if (userModel == null) {
              userModel = (await us.saveUser(
                      UserModel(email: user.email, uid: user.uid).toMap()))
                  .data;
            }
            Response result =
                await _userExpenseService.findExpensesbyUser(user.uid);
            Map<String, dynamic> item = Util.finishRegister(userModel);
            if (item != null) {
              Get.offAllNamed(Routes.PROFILE_UPDATE, arguments: {
                "user": userModel,
                "userexpenses": result.data,
                "params": item,
                "initializing": true,
              });
            } else {
              Get.offAllNamed(Routes.HOME,
                  arguments: {"user": userModel, "userexpenses": result.data});
            }
          }
        }
      }
      this.loading.value = false;
    });
  }

  void setFirstScreen(bool value) => this.firstScreen.value = value;
}
