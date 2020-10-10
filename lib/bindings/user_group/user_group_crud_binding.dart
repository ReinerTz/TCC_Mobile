import 'package:get/get.dart';
import 'package:tcc_project/pages/user_group/pages/crud/user_group_crud_controller.dart';

class UserGroupCrudBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserGroupCrudController>(
      () => UserGroupCrudController(pageArgs: Get.arguments),
    );
  }
}
