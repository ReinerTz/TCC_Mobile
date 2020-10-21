import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcc_project/common/constants.dart';
import 'package:tcc_project/models/user_model.dart';
import 'package:tcc_project/pages/friendshiplist/friendship/friendship_controller.dart';
import 'package:tcc_project/routes/app_routes.dart';
import 'package:tcc_project/widgets/appbar_widget.dart';

class FriendshipPage extends GetWidget<FriendshipController> {
  final search = TextEditingController();
  final friendshipController = Get.find<FriendshipController>();
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

    Widget _buildSubtitle(dynamic data) {
      if (data["uid"] == friendshipController.user.uid) {
        return Text(data["exclusive_user_name"]);
      } else {
        var where = friendshipController.friends
            .where((element) => element["friend"]["uid"] == data["uid"])
            .toList()[0];

        if (where == null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data["exclusive_user_name"]),
              MaterialButton(
                onPressed: () async => await friendshipController
                    .addFriend(UserModel.fromMap(data)),
                color: Get.theme.primaryColor,
                child: Text("Adicionar"),
              )
            ],
          );
        } else {
          switch (where["status"]) {
            case "SENT":
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data["exclusive_user_name"]),
                  MaterialButton(
                    onPressed: () async => await friendshipController
                        .removeFriend(UserModel.fromMap(data)),
                    color: Colors.grey,
                    child: Text("Cancelar solicitação"),
                  )
                ],
              );

            case "RECEIVED":
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data["exclusive_user_name"]),
                  MaterialButton(
                    onPressed: () async => await friendshipController
                        .acceptFriend(UserModel.fromMap(data)),
                    color: Get.theme.primaryColor,
                    child: Text("Aceitar solicitação"),
                  )
                ],
              );
            default:
              return Text(data[
                  "exclusive_user_name"]); // Este caso retorna quando o case for == ACCEPT
          }
        }
      }
    }

    Widget _buildTile(dynamic user) {
      return InkWell(
        child: Card(
          child: ListTile(
            leading: _buildUserAvatar(user["avatar"]),
            title: Text(user["name"]),
            subtitle: _buildSubtitle(user),
          ),
        ),
        onTap: () => Get.toNamed(Routes.PROFILEVIEW, arguments: {"user": user}),
      );
    }

    Widget _buildListTile() {
      if (friendshipController.loading.value) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      return ListView(
        shrinkWrap: true,
        children: friendshipController.list
            .map(
              (data) => _buildTile(data),
            )
            .toList(),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBarWidget(),
        body: Container(
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          child: Obx(() {
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: search,
                        decoration: InputDecoration(
                          hintText: "Encontre um amigo...",
                          suffixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              friendshipController.searchUsers(search.text);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                _buildListTile(),
              ],
            );
          }),
        ),
      ),
    );
  }
}
