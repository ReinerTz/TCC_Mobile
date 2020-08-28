import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcc_project/pages/profile/profile_controller.dart';
import 'package:tcc_project/widgets/drawer_widget.dart';

class ProfilePage extends GetWidget<ProfileController> {
  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("DVDR"),
        ),
        drawer: DrawerWidget(profileController.user, 1),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              
            ],
          ),
        ),
      ),
    );
  }
}
