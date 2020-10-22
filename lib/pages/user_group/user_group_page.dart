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
      if (ugc.groups.isEmpty) {
        return Container(
          height: Get.mediaQuery.size.height * 0.9,
          child: Center(
            child: Text(
              "Você não tem nenhum grupo ainda",
              style: GoogleFonts.roboto(fontSize: 20),
            ),
          ),
        );
      }

      return Obx(
        () => Column(
          children: ugc.groups
              .map(
                (data) => InkWell(
                  onTap: () => ugc.route(data),
                  child: Card(
                    child: ListTile(
                      title: Text(data["title"]),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBarWidget(
        title: "Meus grupos",
      ),
      backgroundColor: Theme.of(context).primaryColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          ugc.createGroup();
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      body: ListView(
        children: [_buildTile()],
      ),
    );
  }
}
