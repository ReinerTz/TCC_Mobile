import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcc_project/models/user_model.dart';
import 'package:tcc_project/pages/friendshiplist/friendship/friendship_controller.dart';
import 'package:tcc_project/widgets/appbar_widget.dart';

class FriendshipPage extends GetWidget<FriendshipController> {
  final search = TextEditingController();
  final friendshipController = Get.find<FriendshipController>();
  @override
  Widget build(BuildContext context) {
    Widget _buildTile(UserModel user) {
      return InkWell(
        child: Card(
          child: ListTile(
            title: Text(user.name),
            subtitle: Text(user.exclusiveUserName),
          ),
        ),
        onTap: () {
          Get.defaultDialog(
            title: user.name,
            confirm: Container(
              color: Colors.green,
              child: IconButton(
                icon: Icon(
                  Icons.person_add,
                ),
                onPressed: () {},
              ),
            ),
            cancel: Container(
              color: Colors.red,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
            content: Row(
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(user.avatar),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Nome: ${user.name}"),
                      Text(user.exclusiveUserName)
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    Widget _buildListTile() {
      if (friendshipController.loading.value) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      return Column(
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
