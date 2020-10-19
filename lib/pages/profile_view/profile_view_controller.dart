import 'package:get/get.dart';
import 'package:tcc_project/models/user_model.dart';

class ProfileViewController extends GetxController {
  UserModel user;
  ProfileViewController({Map pageArgs}) {
    if (pageArgs != null) {
      this.user = UserModel.fromMap(pageArgs["user"]);
    }
  }
}
