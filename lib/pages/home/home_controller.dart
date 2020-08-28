import 'package:get/get.dart';
import 'package:tcc_project/models/user_model.dart';

class HomeController extends GetxController {
  UserModel user;
  HomeController({Map pageArgs}) {
    if (pageArgs != null) {
      this.user = UserModel.fromMap(pageArgs["user"]);
    }
  }
}
