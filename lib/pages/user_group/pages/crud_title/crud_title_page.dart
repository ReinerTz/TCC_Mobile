import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcc_project/pages/user_group/pages/crud_title/crud_title_controller.dart';
import 'package:tcc_project/widgets/appbar_widget.dart';

class CrudTitlePage extends GetWidget<CrudTitleController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: "Meus grupos",
      ),
      backgroundColor: Get.theme.primaryColor,
      body: Container(),
    );
  }
}
