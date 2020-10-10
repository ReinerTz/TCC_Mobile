import 'package:get/get.dart';
import 'package:tcc_project/models/user_model.dart';
import 'package:tcc_project/services/user_service.dart';

class FriendshipController extends GetxController {
  UserModel user;
  RxList<UserModel> list = <UserModel>[].obs;
  RxBool loading = false.obs;
  UserService _service = UserService();

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
        this.list = await _service.getUsersByExclusiveUserName(name);
        // List response =
        //     (await UserService.getUsersByExclusiveUserName(name)).data;

        // this.list.value = response.map<UserModel>((data) {
        //   return UserModel.fromMap(data);
        // }).toList();
      } catch (e) {
        print(e);
      }
    }
    this.loading.value = false;
  }
}
