import 'package:get/get.dart';
import 'package:tcc_project/models/user_model.dart';
import 'package:tcc_project/services/friendship_service.dart';
import 'package:tcc_project/services/user_service.dart';

class FriendshipController extends GetxController {
  UserModel user;
  RxList<dynamic> friends = [].obs;
  RxList<dynamic> list = [].obs;
  RxBool loading = false.obs;
  UserService _service = UserService();
  FriendShipService _serviceFS = FriendShipService();

  FriendshipController({Map pageArgs}) {
    if (pageArgs != null) {
      this.user = UserModel.fromMap(pageArgs["user"]);
    }
  }

  Future<Null> searchUsers(String name) async {
    this.loading.value = true;
    this.list.clear();
    if (name.isNotEmpty) {
      try {
        var response = await _service.getUsersByExclusiveUserName(name);
        this.list.value = response.data ?? List();
        await setFriends();
      } catch (e) {
        print(e);
      }
    }
    this.loading.value = false;
  }

  Future setFriends() async {
    var response = await _serviceFS.getInvitedSent(user.uid);

    this.friends.value = response.data ?? List();
  }

  Future addFriend(UserModel friend) async {
    loading.value = true;
    try {
      this.friends.clear();
      await _serviceFS.sendInvite(user, friend);
      setFriends();
    } finally {
      loading.value = false;
    }
  }

  Future removeFriend(UserModel friend) async {
    loading.value = true;
    try {
      await _serviceFS.sendRejectInvite(friend, user);
      friends.remove((friend as dynamic));

      await setFriends();
      update();
    } finally {
      loading.value = false;
    }
  }

  Future acceptFriend(UserModel friend) async {
    loading.value = true;
    try {
      this.friends.clear();
      await _serviceFS.sendAcceptInvate(friend, user);
      await setFriends();
      update();
    } finally {
      loading.value = false;
    }
  }
}
