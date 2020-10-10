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
    // Widget _buildHeader() {
    //   return Container(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Container(
    //           padding: EdgeInsets.all(8),
    //           child: Text(
    //             "Meus Grupos",
    //             style: GoogleFonts.acme(fontSize: 20, color: Colors.white),
    //           ),
    //         ),
    //         Divider(
    //           color: Colors.white,
    //         ),
    //       ],
    //     ),
    //   );
    // }

    Widget _buildTile() {
      return Column(
        // ignore: null_aware_in_condition
        children: ugc.user?.groups?.isNotEmpty
            ? ugc.user?.groups
                ?.map(
                  (data) => Card(
                    child: ListTile(
                      title: Text(data.title),
                      subtitle: Text("criado em: ${data.createdAt}"),
                    ),
                  ),
                )
                ?.toList()
            : [
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
        // children: [
        //   Card(
        //     child: ListTile(
        //       title: Text("teste"),
        //     ),
        //   ),
        // ],
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
