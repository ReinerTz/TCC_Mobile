import 'package:get/get.dart';
import 'package:tcc_project/models/user_model.dart';
import 'package:tcc_project/services/friendship_service.dart';

class FriendshipListController extends GetxController {
  UserModel user;
  RxList<dynamic> friends = <dynamic>[].obs;
  FriendShipService _service = FriendShipService();

  FriendshipListController({Map pageArgs}) {
    if (pageArgs != null) {
      this.user = pageArgs["user"];
    }
  }

  Future getAllFriends() async {
    var response = await _service.findById(user.uid);
    return response;
  }

  void setList(dynamic list) {
    this.friends.value =
        (list as List).where((element) => element["status"] != 'SENT');
    // this.friends.value = this.friends.where((data) => data.);
  }
}
