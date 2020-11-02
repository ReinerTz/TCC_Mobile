import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcc_project/common/constants.dart';
import 'package:tcc_project/models/user_model.dart';
import 'package:tcc_project/pages/friendshiplist/friendshiplist_controller.dart';
import 'package:tcc_project/routes/app_routes.dart';
import 'package:tcc_project/widgets/appbar_widget.dart';
import 'package:tcc_project/widgets/default_loading_widget.dart';

class FriendshipListPage extends GetWidget<FriendshipListController> {
  final flc = Get.find<FriendshipListController>();

  @override
  @override
  Widget build(BuildContext context) {
    Widget _buildUserAvatar(String image) {
      return Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.fill,
            image: image.isNull
                ? AssetImage(AssetImages.AVATAR)
                : NetworkImage(image),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBarWidget(
        title: "Contatos",
      ),
      body: FutureBuilder(
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
            flc.setList(snapshot.data.data);
            return ListView(
              children: [
                InkWell(
                  child: ListTile(
                    title: Text("Encontrar novos contatos"),
                    trailing: Icon(Icons.search),
                  ),
                  onTap: () => Get.toNamed(Routes.FRIENDSHIP,
                      arguments: {"user": flc.user}),
                ),
                Divider(
                  thickness: 2,
                ),
                Obx(() {
                  if (flc.loading.value) {
                    return DefaultLoadingWidget();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ExpansionTile(
                        title: Text(
                            "Solicitações pendentes: ${flc?.pendings?.length ?? 0}"),
                        children: flc?.pendings?.map<Widget>(
                          (data) {
                            return GestureDetector(
                              onTap: () => Get.toNamed(Routes.PROFILEVIEW,
                                  arguments: {"user": data["friend"]}),
                              child: ListTile(
                                leading:
                                    _buildUserAvatar(data["friend"]["avatar"]),
                                title: Text(data["friend"]
                                        ["exclusive_user_name"] ??
                                    ""),
                                subtitle: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data["friend"]["name"],
                                      ),
                                      Row(
                                        children: [
                                          MaterialButton(
                                            color: Get.theme.primaryColor,
                                            child: Text("Aceitar"),
                                            onPressed: () async => await flc
                                                .acceptFriend(UserModel.fromMap(
                                                    data["friend"])),
                                          ),
                                          Container(
                                            width: 10,
                                          ),
                                          MaterialButton(
                                            color: Colors.grey,
                                            child: Text(
                                              "Recusar",
                                            ),
                                            onPressed: () async =>
                                                await flc.removeFriend(
                                              UserModel.fromMap(data["friend"]),
                                            ),
                                          ),
                                        ],
                                      )
                                    ]),
                              ),
                            );
                          },
                        )?.toList(),
                      ),
                      ExpansionTile(
                        initiallyExpanded: true,
                        title: Text("Contatos: ${flc?.friends?.length ?? 0}"),
                        children: flc?.friends?.map<Widget>(
                          (data) {
                            return GestureDetector(
                              onTap: () => Get.toNamed(Routes.PROFILEVIEW,
                                  arguments: {"user": data["friend"]}),
                              child: ListTile(
                                leading:
                                    _buildUserAvatar(data["friend"]["avatar"]),
                                title: Text(data["friend"]
                                        ["exclusive_user_name"] ??
                                    ""),
                                subtitle: Text(data["friend"]["name"]),
                                trailing: MaterialButton(
                                  color: Colors.grey,
                                  onPressed: () async => await flc.removeFriend(
                                    UserModel.fromMap(data["friend"]),
                                  ),
                                  child: Text("Remover contato"),
                                ),
                              ),
                            );
                          },
                        )?.toList(),
                      ),
                    ],
                  );
                }),
              ],
            );
          }),
    );
  }
}
