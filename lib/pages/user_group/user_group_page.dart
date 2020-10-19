import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tcc_project/pages/user_group/user_group_controller.dart';
import 'package:tcc_project/routes/app_routes.dart';
import 'package:tcc_project/widgets/appbar_widget.dart';

class UserGroupPage extends GetWidget<UserGroupController> {
  final ugc = Get.find<UserGroupController>();
  @override
  Widget build(BuildContext context) {
    Widget _buildTile() {
      return Column(
        children: [
          Container(
            height: Get.mediaQuery.size.height * 0.9,
            child: Center(
              child: Text(
                "Você não tem nenhum grupo ainda",
                style: GoogleFonts.roboto(fontSize: 20),
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBarWidget(
        title: "Meus grupos",
      ),
      backgroundColor: Theme.of(context).primaryColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.USER_GROUP_CRUD, arguments: {"user": ugc.user});
        },
        child: Icon(Icons.add),
      ),
      body: ListView(
        children: [_buildTile()],
      ),
    );
  }
}
