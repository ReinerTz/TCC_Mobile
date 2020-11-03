import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:tcc_project/models/user_model.dart';
import 'package:tcc_project/routes/app_routes.dart';
import 'package:tcc_project/services/group_service.dart';

class HomeController extends GetxController {
  UserModel user;
  GroupService _groupService = GroupService();
  RxList<dynamic> userExpenses = [].obs;
  RxList<dynamic> listItems = [].obs;

  RxBool loading = false.obs;
  HomeController({Map pageArgs}) {
    if (pageArgs != null) {
      this.user = UserModel.fromMap(pageArgs["user"]);
      this.userExpenses.value = pageArgs["userexpenses"];
    }
    _buildListItems();
  }

  Future routes(String route) async {
    if (route == Routes.USER_GROUP) {
      try {
        loading.value = true;
        Response response = await _groupService.getByUser(this.user.uid);
        if (response.statusCode == 200) {
          Get.toNamed(route, arguments: {
            "user": this.user,
            "groups": response.data ?? List<dynamic>()
          });
        }
      } finally {
        loading.value = false;
      }
    } else {
      Get.toNamed(route, arguments: {"user": this.user});
    }
  }

  void _buildListItems() {
    loading.value = true;

    try {
      listItems.clear();

      this.userExpenses.forEach((data) {
        var item = listItems.isEmpty ? null : _getItem(data);
        if (item == null) {
          listItems.add(data);
        }
      });
    } finally {
      loading.value = false;
    }
  }

  dynamic _getItem(dynamic data) {
    for (dynamic element in listItems) {
      if (element["userGroup"]["group"]["id"] ==
          data["userGroup"]["group"]["id"]) {
        element["price"] += data["price"];
        return element;
      }
    }

    return null;
  }
}
