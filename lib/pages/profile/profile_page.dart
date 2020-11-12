import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tcc_project/common/constants.dart';
import 'package:tcc_project/pages/profile/profile_controller.dart';
import 'package:tcc_project/routes/app_routes.dart';
import 'package:tcc_project/utils/util.dart';
import 'package:tcc_project/widgets/appbar_widget.dart';
import 'package:tcc_project/widgets/drawer_widget.dart';

class ProfilePage extends GetWidget<ProfileController> {
  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();
    final _picker = ImagePicker();

    final df = DateFormat("dd/MM/yyyy");
    final items = Util.items(profileController.user);

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
            child: Image.asset(AssetImages.AVATAR,
                fit: BoxFit.fill,
                height: MediaQuery.of(context).size.width,
                width: double.infinity),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(border: Border.all()),
            child: Image.network(profileController.avatar.value,
                fit: BoxFit.fill,
                height: MediaQuery.of(context).size.width,
                width: double.infinity),
          ),
        );
      });
    }

    Widget _buildTile(dynamic data) {
      return Column(
        children: [
          ListTile(
            onTap: data["canChange"]
                ? () {
                    Get.offAllNamed(Routes.PROFILE_UPDATE, arguments: {
                      "user": profileController.user.toMap(),
                      "userexpenses": profileController.userExpenses,
                      "params": data,
                      "initializing": false,
                    });
                  }
                : null,
            title: Text(data["field"]),
            subtitle: Text(data["value"] is DateTime
                ? df.format(data["value"])
                : data["value"] ?? "Não preenchido"),
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
        drawer: DrawerWidget(
            profileController.user, 1, profileController.userExpenses),
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
