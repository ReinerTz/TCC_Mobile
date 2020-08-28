import 'package:get/get.dart';
import 'package:tcc_project/models/user_model.dart';

class ProfileController extends GetxController {
  UserModel user;
  ProfileController({Map pageArgs}) {
    if (pageArgs != null) {
      this.user = UserModel.fromMap(pageArgs["user"]);
    }
  }
}
