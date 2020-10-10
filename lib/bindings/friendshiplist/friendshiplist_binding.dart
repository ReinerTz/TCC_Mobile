import 'package:get/get.dart';
import 'package:tcc_project/pages/friendshiplist/friendshiplist_controller.dart';

class FriendshipListBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FriendshipListController>(
      () => FriendshipListController(pageArgs: Get.arguments),
    );
  }
}
