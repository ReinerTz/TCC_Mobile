import 'package:get/get.dart';
import 'package:tcc_project/models/user_model.dart';
import 'package:tcc_project/services/friendship_service.dart';

class FriendshipListController extends GetxController {
  UserModel user;
  RxList<dynamic> friends = <dynamic>[].obs;
  RxList<dynamic> pendings = <dynamic>[].obs;
  FriendShipService _service = FriendShipService();
  RxBool loading = false.obs;

  FriendshipListController({Map pageArgs}) {
    if (pageArgs != null) {
      this.user = pageArgs["user"];
    }
  }

  Future getAllFriends() async {
    var response = await _service.findById(user.uid);
    setList(response.data);
    return response;
  }

  void setList(List list) {
    friends = <dynamic>[].obs;
    pendings = <dynamic>[].obs;
    friends.clear();
    pendings.clear();

    // necessário, pois se a lista vier como null do ws vai dar pau.
    this.friends.value = List.from(
      list?.where((element) => element["status"] == 'ACCEPT')?.toList() ??
          List(),
    );
    this.pendings.value = List.from(
      list?.where((element) => element["status"] == 'RECEIVED')?.toList() ??
          List(),
    );
  }

  Future acceptFriend(UserModel friend) async {
    loading.value = true;
    try {
      await _service.sendAcceptInvate(friend, user);
      await getAllFriends();
    } finally {
      loading.value = false;
    }
  }

  Future removeFriend(UserModel friend) async {
    loading.value = true;
    try {
      await _service.sendRejectInvite(friend, user);
      await getAllFriends();
    } finally {
      loading.value = false;
    }
  }
}
