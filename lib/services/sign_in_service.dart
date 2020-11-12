import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcc_project/services/user_service.dart';

class SignInService extends GetxController {
  UserService userService = UserService();

  // Future<UserModel> signIn(String email, String password) async {
  //   await FirebaseAuth.instance.signOut();
  //   FirebaseUser user = await signUpFirebase(email, password);
  //   Response response = await signInWithUid(user.uid);

  //   if (response.statusCode == 200) {
  //     return UserModel.fromMap(response.data);
  //   }
  //   return null;
  // }

  Future<User> signInFirebase(String email, String password) async {
    try {
      return (await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password))
          .user;
    } catch (error) {
      print(error);
      Get.defaultDialog(
        title: "Erro",
        middleText: "Ocorreu um erro ao tentar realizar o login ${error.code}",
        confirm: MaterialButton(
          child: Text("Ok"),
          color: Get.theme.primaryColor,
          onPressed: () => Get.back(),
        ),
      );
      return null;
    }
  }

  Future signInWithUid(String uid) async {
    try {
      return await userService.getUser(uid);
    } catch (error) {
      return null;
    }
  }

  Future<bool> recoverPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
