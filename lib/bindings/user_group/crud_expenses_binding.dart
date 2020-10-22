import 'package:get/get.dart';
import 'package:tcc_project/pages/user_group/pages/crud_expenses/crud_expenses_controller.dart';

class CrudExpensesBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CrudExpensesController>(
      () => CrudExpensesController(pageArgs: Get.arguments),
    );
  }
}
