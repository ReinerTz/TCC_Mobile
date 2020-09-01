import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tcc_project/pages/profile/profile_controller.dart';
import 'package:tcc_project/routes/app_routes.dart';
import 'package:tcc_project/widgets/appbar_widget.dart';
import 'package:tcc_project/widgets/drawer_widget.dart';

class ProfilePage extends GetWidget<ProfileController> {
  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();
    final _picker = ImagePicker();
    final items = [
      {
        "field": "Nome",
        "value": profileController.user.name,
        "fieldName": "name",
        "canChange": true,
      },
      {
        "field": "Email",
        "value": profileController.user.email,
        "fieldName": "email",
        "canChange": false
      },
      {
        "field": "Data de nascimento",
        "value": profileController.user.birthday,
        "fieldName": "birthday",
        "canChange": false
      },
      {
        "field": "Telefone",
        "value": profileController.user.phone,
        "fieldName": "phone",
        "canChange": true
      },
      {
        "field": "Como os outros te encontram?",
        "value": profileController.user.exclusiveUserName,
        "fieldName": "exclusive_user_name",
        "canChange": true
      },
    ];

    Widget _buildProfileImage() {
      return Obx(() {
        if (profileController.isLoading.value) {
          return Container(
            height: MediaQuery.of(context).size.width,
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Carregando foto..."),
                  SizedBox(
                    height: 10,
                  ),
                  CircularProgressIndicator()
                ],
              ),
            ),
          );
        }

        if ((profileController.avatar.value == null) ||
            (profileController.avatar.value.isEmpty)) {
          return Container(
            decoration: BoxDecoration(border: Border.all()),
            child: Image.asset("lib/assets/images/avatar-default.png",
                fit: BoxFit.fill,
                height: MediaQuery.of(context).size.width,
                width: double.infinity),
          );
        }

        return Image.network(profileController.avatar.value,
            fit: BoxFit.fill,
            height: MediaQuery.of(context).size.width,
            width: double.infinity);
      });
    }

    Widget _buildTile(dynamic data) {
      return Column(
        children: [
          ListTile(
            onTap: data["canChange"]
                ? () {
                    Get.offAllNamed(Routes.PROFILE_UPDATE, arguments: {
                      "user": profileController.user,
                      "params": data
                    });
                  }
                : null,
            title: Text(data["field"]),
            subtitle: Text(data["value"] ?? "Não preenchido"),
            trailing: data["canChange"]
                ? Icon(
                    Icons.chevron_right,
                    color: Colors.black,
                  )
                : null,
          ),
        ],
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBarWidget(),
        drawer: DrawerWidget(profileController.user, 1),
        body: Container(
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          child: ListView(
            children: [
              GestureDetector(
                onTap: () async {
                  PickedFile image =
                      await _picker.getImage(source: ImageSource.gallery);
                  if (image != null) {
                    profileController.updateProfileImage(File(image.path));
                  }
                },
                child: _buildProfileImage(),
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: items.map((data) => _buildTile(data)).toList()),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
