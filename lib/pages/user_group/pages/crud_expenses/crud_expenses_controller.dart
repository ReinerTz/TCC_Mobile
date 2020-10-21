import 'package:get/get.dart';
import 'package:tcc_project/models/user_model.dart';

class CrudExpensesController extends GetxController {
  UserModel user;
  RxList<dynamic> groups = <dynamic>[].obs;
  CrudExpensesController({Map pageArgs}) {
    this.user = pageArgs["user"];
  }
}
