import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcc_project/models/user_model.dart';
import 'package:tcc_project/models/usergroup_model.dart';
import 'package:tcc_project/pages/user_group/pages/crud/user_group_crud_controller.dart';
import 'package:tcc_project/services/usergroup_service.dart';

class CrudPeoplesController extends GetxController {
  UserModel user;
  RxList<dynamic> peoples = [].obs;
  RxList<dynamic> friends = [].obs;
  dynamic group = [].obs;
  UserGroupService _userGroupService = UserGroupService();
  final ugcc = Get.find<UserGroupCrudController>();

  CrudPeoplesController({Map pageArgs}) {
    this.user = UserModel.fromMap(pageArgs["user"]);
    this.peoples.value = pageArgs["peoples"];
    this.friends.value = pageArgs["friends"];
    this.group = pageArgs["group"];
  }

  Future addAnonimous() async {
    if (group != null) {
      UserGroupModel userGroupModel = UserGroupModel();
      userGroupModel.admin = false;
      userGroupModel.receptor = false;
      userGroupModel.group = group;

      Response response = await _userGroupService.save(userGroupModel.toMap());
      if (response.statusCode == 200) {
        Get.defaultDialog(
          title: "Informação",
          middleText: "Usuário Anônimo adicionado com sucesso",
          backgroundColor: Colors.white,
          confirm: MaterialButton(
            color: Get.theme.primaryColor,
            child: Text("Ok"),
            onPressed: () => Get.back(),
          ),
        );

        ugcc.peoples.add(response.data);
        this.peoples = ugcc.peoples;
      }
    } else {
      throw Exception("O grupo deve estar preenchido");
    }
  }

  Future addPeople(dynamic user) async {
    if (group != null) {
      UserGroupModel userGroupModel = UserGroupModel();
      userGroupModel.admin = false;
      userGroupModel.receptor = false;
      userGroupModel.group = group;
      userGroupModel.user = UserModel.fromMap(user);

      Response response = await _userGroupService.save(userGroupModel.toMap());
      if (response.statusCode == 200) {
        Get.defaultDialog(
          title: "Informação",
          middleText: "${user["name"]} foi adicionado",
          backgroundColor: Colors.white,
          confirm: MaterialButton(
            color: Get.theme.primaryColor,
            child: Text("Ok"),
            onPressed: () => Get.back(),
          ),
        );
        ugcc.peoples.add(response.data);
        this.peoples = ugcc.peoples;
      }
    } else {
      throw Exception("O grupo deve estar preenchido");
    }
  }
}
