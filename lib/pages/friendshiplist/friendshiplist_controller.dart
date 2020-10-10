import 'package:get/get.dart';
import 'package:tcc_project/models/user_model.dart';
import 'package:tcc_project/services/friendship_service.dart';
import 'package:tcc_project/services/user_service.dart';

class FriendshipListController extends GetxController {
  UserModel user;
  RxList<UserModel> users = <UserModel>[].obs;
  FriendShipService _service = FriendShipService();

  FriendshipListController({Map pageArgs}) {
    if (pageArgs != null) {
      this.user = pageArgs["user"];
    }
  }

  Future getAllFriends() {
    var response = _service.findById(user.uid);
    return response;
  }
}
