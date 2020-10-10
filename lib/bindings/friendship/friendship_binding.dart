import 'package:get/get.dart';
import 'package:tcc_project/pages/friendshiplist/friendship/friendship_controller.dart';

class FriendshipBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FriendshipController>(
      () => FriendshipController(pageArgs: Get.arguments),
    );
  }
}
