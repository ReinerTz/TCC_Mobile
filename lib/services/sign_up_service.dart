import 'package:firebase_auth/firebase_auth.dart';
import 'package:tcc_project/models/user_model.dart';
import 'package:tcc_project/services/user_service.dart';

class SignUpService {
  Future signUp(UserModel userModel, String password) async {
    FirebaseUser user = await signUpFirebase(userModel.email, password);
    UserService userService = UserService();
    userModel.uid = user.uid;
    try {
      return userService.saveUser(userModel.toMap());
    } catch (e) {
      return e;
    }
  }

  Future<FirebaseUser> signUpFirebase(String email, String password) async {
    return (await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password))
        .user;
  }
}
