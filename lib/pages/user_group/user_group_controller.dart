import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:tcc_project/models/group_model.dart';
import 'package:tcc_project/models/user_model.dart';
import 'package:tcc_project/models/usergroup_model.dart';
import 'package:tcc_project/routes/app_routes.dart';
import 'package:tcc_project/services/expense_service.dart';
import 'package:tcc_project/services/group_service.dart';
import 'package:tcc_project/services/userexpense_service.dart';
import 'package:tcc_project/services/usergroup_service.dart';
import 'package:uuid/uuid.dart';

class UserGroupController extends GetxController {
  UserModel user;
  RxBool loading = false.obs;
  GroupService _service = GroupService();
  UserGroupService _userGroupService = UserGroupService();
  ExpenseService _expenseService = ExpenseService();
  UserExpenseService _userExpenseService = UserExpenseService();

  RxList<dynamic> groups = <dynamic>[].obs;

  UserGroupController({Map pageArgs}) {
    this.user = pageArgs["user"];
    this.groups.value = pageArgs["groups"];
  }

  Future createGroup() async {
    loading.value = true;
    try {
      GroupModel group = GroupModel();
      group.description = "";
      group.sharedKey = Uuid().v1();
      group.title = "Grupo do ${this.user.name}";
      group.closed = false;

      Response result = await _service.saveGroup(group.toMap());
      if (result.statusCode == 200) {
        GroupModel group = GroupModel.fromMap(result.data);
        UserGroupModel userGroupModel = UserGroupModel();
        userGroupModel.admin = true;
        userGroupModel.receptor = true;
        userGroupModel.group = group;
        userGroupModel.user = this.user;
        result = await _userGroupService.save(userGroupModel.toMap());

        if (result.statusCode == 200) {
          // ignore: invalid_use_of_protected_member
          this.groups.value.add(result.data);
          Get.toNamed(Routes.USER_GROUP_CRUD, arguments: {
            "user": this.user.toMap(),
            "group": group.toMap(),
            "expenses": [],
            "peoples": [result.data],
            "userexpense": [],
          });
        }
      }
    } finally {
      loading.value = false;
    }
  }

  Future<void> refreshData() async {
    try {
      this.loading.value = true;
      this.groups.value = (await _service.getByUser(this.user.uid)).data;
    } finally {
      this.loading.value = false;
    }
  }

  Future route(dynamic data) async {
    loading.value = true;
    try {
      Response response = await _expenseService.getByGroup(data["id"]);
      if (response.statusCode == 200) {
        var expenses = response.data ?? List();
        response = await _userGroupService.findAllUsersByGroup(data["id"]);
        if (response.statusCode == 200) {
          dynamic peoples = response.data;
          response = await _userExpenseService.findExpensesbyGroup(data["id"]);
          if (response.statusCode == 200) {
            Get.toNamed(Routes.USER_GROUP_CRUD, arguments: {
              "user": this.user.toMap(),
              "group": data,
              "expenses": expenses,
              "peoples": peoples,
              "userexpense": response.data ?? [],
            });
          }
        }
      }
    } finally {
      loading.value = false;
    }
  }
}
