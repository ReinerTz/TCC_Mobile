import 'package:get/get.dart';
import 'package:tcc_project/pages/profile/profile_controller.dart';

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(
      () => ProfileController(pageArgs: Get.arguments),
    );
  }
}
