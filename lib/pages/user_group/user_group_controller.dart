import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:tcc_project/models/group_model.dart';
import 'package:tcc_project/models/user_model.dart';
import 'package:tcc_project/models/usergroup_model.dart';
import 'package:tcc_project/routes/app_routes.dart';
import 'package:tcc_project/services/expense_service.dart';
import 'package:tcc_project/services/group_service.dart';
import 'package:tcc_project/services/usergroup_service.dart';
import 'package:uuid/uuid.dart';

class UserGroupController extends GetxController {
  UserModel user;
  GroupService _service = GroupService();
  UserGroupService _userGroupService = UserGroupService();
  ExpenseService _expenseService = ExpenseService();

  RxList<dynamic> groups = <dynamic>[].obs;

  UserGroupController({Map pageArgs}) {
    this.user = pageArgs["user"];
    this.groups.value = pageArgs["groups"];
  }

  Future createGroup() async {
    GroupModel gm = GroupModel();
    gm.title = "Grupo do ${this.user.name}";
    gm.description = "";
    GroupModel group = GroupModel();
    group.description = "";
    group.sharedKey = Uuid().v1();
    group.title = "Grupo do ${this.user.name}";

    Response result = await _service.saveGroup(group.toMap());
    if (result.statusCode == 200) {
      GroupModel group = GroupModel.fromMap(result.data);
      this.groups.add(group.toMap());
      UserGroupModel userGroupModel = UserGroupModel();
      userGroupModel.admin = true;
      userGroupModel.receptor = true;
      userGroupModel.group = group;
      userGroupModel.user = this.user;
      result = await _userGroupService.save(userGroupModel.toMap());
      if (result.statusCode == 200) {
        Get.toNamed(Routes.USER_GROUP_CRUD, arguments: {
          "user": this.user.toMap(),
          "group": group.toMap(),
          "expenses": [],
          "peoples": [result.data]
        });
      }
    }
  }

  Future route(dynamic data) async {
    Response response = await _expenseService.getByGroup(data["id"]);
    if (response.statusCode == 200) {
      var expenses = response.data;
      response = await _userGroupService.findAllUsersByGroup(data["id"]);
      if (response.statusCode == 200) {
        Get.toNamed(Routes.USER_GROUP_CRUD, arguments: {
          "user": this.user.toMap(),
          "group": data,
          "expenses": expenses,
          "peoples": response.data
        });
      }
    }
  }
}
