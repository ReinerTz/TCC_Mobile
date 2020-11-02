import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcc_project/common/constants.dart';
import 'package:tcc_project/models/user_model.dart';
import 'package:tcc_project/routes/app_routes.dart';
import 'package:tcc_project/widgets/custom_list_tile_widget.dart';

class DrawerWidget extends StatefulWidget {
  final UserModel userModel;
  final int actualPage;
  DrawerWidget(this.userModel, this.actualPage);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    Widget _buildPerfilAvatar() {
      if ((widget.userModel.avatar != null) &&
          (widget.userModel.avatar.isNotEmpty)) {
        return Image.network(
          widget.userModel.avatar,
          width: 100,
          height: 100,
          fit: BoxFit.fill,
        );
      }

      return Image.asset(
        AssetImages.AVATAR,
        width: 100,
        height: 100,
        fit: BoxFit.fill,
      );
    }

    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(widget.userModel.name ?? ""),
            accountEmail: Text(widget.userModel.email ?? ""),
            currentAccountPicture: _buildPerfilAvatar(),
          ),
          CustomListTileWidget(
            icon: Icons.home,
            title: "Home",
            actualPage: widget.actualPage,
            page: 0,
            arguments: {"user": widget.userModel.toMap()},
            route: Routes.HOME,
          ),

          CustomListTileWidget(
            icon: Icons.account_circle,
            title: "Perfil",
            actualPage: widget.actualPage,
            page: 1,
            arguments: {"user": widget.userModel},
            route: Routes.PROFILE,
          ),

          // CustomListTileWidget(
          //     Icons.account_circle, "Home", widget.actualPage, 0, Routes.HOME),
          // CustomListTileWidget(Icons.account_circle, "Perfil",
          //     widget.actualPage, 1, Routes.PROFILE),
          ListTile(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Get.offAllNamed(Routes.INITIAL);
            },
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.grey,
            ),
            title: Text("Deslogar"),
          ),
        ],
      ),
    );
  }
}
