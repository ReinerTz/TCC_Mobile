import 'package:get/get.dart';
import 'package:tcc_project/models/user_model.dart';
import 'package:tcc_project/services/friendship_service.dart';
import 'package:tcc_project/services/user_service.dart';

class FriendshipController extends GetxController {
  UserModel user;
  RxList<dynamic> list = [].obs;
  RxBool loading = false.obs;
  UserService _service = UserService();

  FriendShipService _serviceFS = FriendShipService();

  FriendshipController({Map pageArgs}) {
    if (pageArgs != null) {
      this.user = pageArgs["user"];
    }
  }

  Future<Null> searchUsers(String name) async {
    this.loading.value = true;
    this.list.clear();
    if (name.isNotEmpty) {
      try {
        var response = await _service.getUsersByExclusiveUserName(name);
        this.list.value = response.data ?? List();
      } catch (e) {
        print(e);
      }
    }
    this.loading.value = false;
  }

  Future addFriend(UserModel friend) async {
    await _serviceFS.sendInvite(user, friend);
  }
}
