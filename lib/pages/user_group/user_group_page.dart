import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tcc_project/common/constants.dart';
import 'package:tcc_project/pages/user_group/user_group_controller.dart';
import 'package:tcc_project/widgets/appbar_widget.dart';
import 'package:tcc_project/widgets/default_loading_widget.dart';

class UserGroupPage extends GetWidget<UserGroupController> {
  final ugc = Get.find<UserGroupController>();
  @override
  Widget build(BuildContext context) {
    Widget _buildUserAvatar({String image = ""}) {
      return Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.fill,
            image: image.isEmpty
                ? AssetImage(AssetImages.GROUP)
                : NetworkImage(image),
          ),
        ),
      );
    }

    Widget _buildTiles() {
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

      return Obx(() {
        if (ugc.loading.value) {
          return AspectRatio(
            aspectRatio: 0.6,
            child: Center(
              child: DefaultLoadingWidget(),
            ),
          );
        }

        return Column(
          children: ugc.groups
              .map(
                (data) => InkWell(
                  onTap: () => ugc.route(data),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: ListTile(
                        leading: _buildUserAvatar(image: data["avatar"] ?? ""),
                        title: Text(data["title"] ?? ""),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        );
      });
    }

    return Scaffold(
        appBar: AppBarWidget(
          title: "Meus grupos",
        ),
        backgroundColor: Get.theme.primaryColor,
        floatingActionButton: ugc.loading.value
            ? null
            : FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () async {
                  await ugc.createGroup();
                },
                child: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
              ),
        body: SingleChildScrollView(
          child: _buildTiles(),
        ));
  }
}
