import 'package:get/get.dart';
import 'package:tcc_project/pages/user_group/pages/crud_peoples/crud_peoples_controller.dart';

class CrudPeoplesBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CrudPeoplesController>(
      () => CrudPeoplesController(pageArgs: Get.arguments),
    );
  }
}
