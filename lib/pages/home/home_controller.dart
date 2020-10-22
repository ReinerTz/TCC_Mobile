import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:tcc_project/models/user_model.dart';
import 'package:tcc_project/routes/app_routes.dart';
import 'package:tcc_project/services/group_service.dart';

class HomeController extends GetxController {
  UserModel user;
  GroupService _groupService = GroupService();
  HomeController({Map pageArgs}) {
    if (pageArgs != null) {
      this.user = pageArgs["user"];
    }
  }

  Future routes(String route) async {
    if (route == Routes.USER_GROUP) {
      Response response = await _groupService.getByUser(this.user.uid);
      if (response.statusCode == 200) {
        Get.toNamed(route, arguments: {
          "user": this.user,
          "groups": response.data ?? List<dynamic>()
        });
      }
    } else {
      Get.toNamed(route, arguments: {"user": this.user});
    }
  }
}
