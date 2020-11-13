import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tcc_project/common/constants.dart';
import 'package:tcc_project/pages/profile_view/profile_view_controller.dart';
import 'package:tcc_project/widgets/appbar_widget.dart';
import 'package:intl/intl.dart';

class ProfileViewPage extends GetWidget<ProfileViewController> {
  final profileController = Get.find<ProfileViewController>();
  final df = DateFormat("dd/MM/yyyy");

  @override
  Widget build(BuildContext context) {
    Widget _buildProfileImage() {
      return CircleAvatar(
        radius: 35,
        backgroundImage: profileController.user.avatar.isNullOrBlank
            ? AssetImage(AssetImages.AVATAR)
            : NetworkImage(profileController.user.avatar),
      );
    }

    Widget _buildTile({Icon icon, String subtitle, String title}) {
      return ListTile(
        leading: icon,
        subtitle: Text(subtitle),
        title: Text(title),
      );
    }

    Widget _buildBody() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Card(
          child: Column(
            children: [
              _buildTile(
                icon: Icon(Icons.email),
                subtitle: profileController.user.email,
                title: "Email",
              ),
              _buildTile(
                icon: Icon(Icons.phone),
                subtitle: profileController.user.phone.isNullOrBlank
                    ? "Nenhum telefone cadastrado"
                    : profileController.user.phone,
                title: "Telefone",
              ),
              _buildTile(
                icon: Icon(Icons.calendar_today),
                subtitle: profileController.user.birthday == null
                    ? "Nenhuma data cadastrada"
                    : df.format(profileController.user.birthday),
                title: "Data de nascimento",
              ),
            ],
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBarWidget(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 28, top: 50),
                  child: _buildProfileImage(),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 38),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profileController.user.name,
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            color: Colors.white),
                      ),
                      Text(
                        profileController.user.exclusiveUserName,
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.white),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 50,
            ),
            _buildBody(),
          ],
        ),
      ),
    );
  }
}
