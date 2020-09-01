import 'package:get/get.dart';
import 'package:tcc_project/pages/profile_udpate/profile_update_controller.dart';

class ProfileUpdateBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileUpdateController>(
      () => ProfileUpdateController(pageArgs: Get.arguments),
    );
  }
}
