import 'package:firebase_auth/firebase_auth.dart';
import 'package:tcc_project/models/user_model.dart';
import 'package:tcc_project/services/user_service.dart';

class SignInService {
  
  Future<UserModel> signIn(String email, String password) async {
    FirebaseUser user = await signUpFirebase(email, password);
    UserService userService = UserService();
    try {
      UserModel response = await userService.getUser(user.uid);
      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<FirebaseUser> signUpFirebase(String email, String password) async {
    return (await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password))
        .user;
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
