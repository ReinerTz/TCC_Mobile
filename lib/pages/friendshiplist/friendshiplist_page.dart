import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcc_project/pages/friendshiplist/friendshiplist_controller.dart';
import 'package:tcc_project/routes/app_routes.dart';
import 'package:tcc_project/widgets/appbar_widget.dart';

class FriendshipListPage extends GetWidget<FriendshipListController> {
  final flc = Get.find<FriendshipListController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: "Contatos",
      ),
      body: ListView(
        children: [
          InkWell(
            child: ListTile(
              title: Text("Encontrar novos contatos"),
              trailing: Icon(Icons.search),
            ),
            onTap: () =>
                Get.toNamed(Routes.FRIENDSHIP, arguments: {"user": flc.user}),
          ),
          Divider(
            thickness: 2,
          ),
          FutureBuilder(
              future: flc.getAllFriends(),
              builder: (context, snapshot) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text("teste"),
                    ),
                    ListTile(
                      title: Text("teste"),
                    ),
                  ],
                );
              }),
          // Column(
          //   children: flc.users
          //       .map(
          //         (data) => ListTile(title: Text(data.name)),
          //       )
          //       .toList(),
          // ),
        ],
      ),
    );
  }
}
