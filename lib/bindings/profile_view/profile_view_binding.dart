import 'package:get/get.dart';
import 'package:tcc_project/pages/profile_view/profile_view_controller.dart';

class ProfileViewBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileViewController>(
      () => ProfileViewController(pageArgs: Get.arguments),
    );
  }
}
