import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcc_project/pages/home/home_controller.dart';
import 'package:tcc_project/widgets/drawer_widget.dart';

class HomePage extends GetWidget<HomeController> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text("DVDR"),
          ),
          drawer: DrawerWidget(Get.find<HomeController>().user, 0),
          body: Container()),
    );
  }
}
