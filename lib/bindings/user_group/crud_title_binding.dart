import 'package:get/get.dart';
import 'package:tcc_project/pages/user_group/pages/crud_title/crud_title_controller.dart';

class CrudTitleBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CrudTitleController>(
      () => CrudTitleController(pageArgs: Get.arguments),
    );
  }
}
