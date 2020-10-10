import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tcc_project/pages/home/home_controller.dart';
import 'package:tcc_project/routes/app_routes.dart';
import 'package:tcc_project/widgets/appbar_widget.dart';
import 'package:tcc_project/widgets/drawer_widget.dart';

class HomePage extends GetWidget<HomeController> {
  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    Widget _buildCard({String text, String route = ""}) {
      return InkWell(
        onTap: route != null
            ? () {
                Get.toNamed(route, arguments: {"user": homeController.user});
              }
            : null,
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    text,
                    style: GoogleFonts.arapey(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
          appBar: AppBarWidget(),
          drawer: DrawerWidget(homeController.user, 0),
          backgroundColor: Theme.of(context).primaryColor,
          body: GridView.count(
            padding: EdgeInsets.all(8),
            shrinkWrap: true,
            crossAxisCount: 2,
            children: [
              //_buildCard(text: "Faça uma vaquinha"),
              _buildCard(text: "Histórico"),
              _buildCard(text: "Grupos", route: Routes.USER_GROUP),
              _buildCard(text: "Contatos", route: Routes.FRIENDSHIPLIST),
              // _buildCard(text: "Quem somos nós?"),
            ],
          )),
    );
  }
}
