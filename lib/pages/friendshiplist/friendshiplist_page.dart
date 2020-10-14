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
    _buildUserAvatar(String image) {
      if (image.isNull) {
        return ClipOval(
          child: Image.asset("lib/assets/images/avatar-default.png"),
        );
      }

      return ClipOval(
        child: Image.network(image),
      );
    }

    _buildTrailing(String status) {
      switch (status) {
        case "ACCEPT":
          return IconButton(icon: Icon(Icons.remove), onPressed: () => null);
        case "RECEIVED":
          return IconButton(
            icon: Icon(Icons.add),
            onPressed: () => null,
          );
      }
    }

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
                if (snapshot.data == null) {
                  return Container(
                    height: Get.mediaQuery.size.height,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                flc.friends.value = snapshot.data.data;

                return Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: flc.friends.map<Widget>(
                      (data) {
                        return ListTile(
                          leading: _buildUserAvatar(data["friend"]["avatar"]),
                          title:
                              Text(data["friend"]["exclusive_user_name"] ?? ""),
                          subtitle: Text(data["friend"]["name"]),
                          trailing: _buildTrailing(data["status"]),
                        );
                      },
                    ).toList(),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
