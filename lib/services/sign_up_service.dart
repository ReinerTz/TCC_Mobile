import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tcc_project/models/user_model.dart';
import 'package:tcc_project/services/user_service.dart';

class SignUpService {
  Future<bool> signUp(UserModel userModel, String password) async {
    FirebaseUser user = await signUpFirebase(userModel.email, password);
    if (user == null) {
      return false;
    }

    UserService userService = UserService();
    userModel.uid = user.uid;

    try {
      var response = await userService.saveUser(userModel.toMap());
      print(response);
      return response != null;
    } catch (e) {
      Get.defaultDialog(title: "Ocorreu um erro", middleText: e);
      return false;
    }
  }

  Future<FirebaseUser> signUpFirebase(String email, String password) async {
    FirebaseUser user;

    try {
      user = (await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password))
          .user;
    } catch (e) {
      Get.defaultDialog(title: "Ocorreu um erro", middleText: e.message);
    }
    return user;
  }
}
