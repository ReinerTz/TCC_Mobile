import 'package:get/get.dart';
import 'package:tcc_project/models/user_model.dart';

class CrudTitleController extends GetxController {
  UserModel user;
  RxList<dynamic> groups = <dynamic>[].obs;
  CrudTitleController({Map pageArgs}) {
    this.user = pageArgs["user"];
  }
}
