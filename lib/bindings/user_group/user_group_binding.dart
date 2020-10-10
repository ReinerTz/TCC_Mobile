import 'package:get/get.dart';
import 'package:tcc_project/pages/user_group/user_group_controller.dart';

class UserGroupBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserGroupController>(
      () => UserGroupController(pageArgs: Get.arguments),
    );
  }
}
