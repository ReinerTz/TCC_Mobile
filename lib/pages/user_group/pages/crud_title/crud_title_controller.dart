import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:tcc_project/models/group_model.dart';
import 'package:tcc_project/pages/user_group/pages/crud/user_group_crud_controller.dart';
import 'package:tcc_project/services/group_service.dart';

class CrudTitleController extends GetxController {
  GroupModel group;
  GroupService _service = GroupService();
  CrudTitleController({Map pageArgs}) {
    this.group = pageArgs["group"];
  }

  void setTitle(String value) => this.group.title = value;
  void setDescription(String value) => this.group.description = value;

  Future save() async {
    Response response = await _service.saveGroup(this.group.toMap());
    if (response.statusCode == 200) {
      UserGroupCrudController screen = Get.find<UserGroupCrudController>();
      screen.group.value = GroupModel.fromMap(response.data);
      Get.back();
    }
  }
}
