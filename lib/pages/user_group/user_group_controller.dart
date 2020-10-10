import 'package:get/get.dart';
import 'package:tcc_project/models/user_model.dart';

class UserGroupController extends GetxController {
  UserModel user;
  RxList<dynamic> groups = <dynamic>[].obs;
  UserGroupController({Map pageArgs}) {
    this.user = pageArgs["user"];
  }
}
