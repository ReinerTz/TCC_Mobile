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

    Widget _buildListViewItem(
        {@required String text, @required String route, IconData icon}) {
      return GestureDetector(
        onTap: () => homeController.routes(route),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Get.theme.primaryColor.withBlue(200),
              border: Border.all(),
            ),
            width: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                ),
                Text(
                  text,
                  style: GoogleFonts.roboto(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget _buildHistoricItem() {
      return Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.white, border: Border.all()),
          child: ListTile(
            title: Text("teste"),
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBarWidget(),
        drawer: DrawerWidget(homeController.user, 0),
        backgroundColor: Theme.of(context).primaryColor,
        body: Stack(
          children: [
            Positioned(
              top: 5,
              height: Get.mediaQuery.size.height * .75,
              left: 5,
              right: 5,
              child: ListView(
                children: [
                  _buildHistoricItem(),
                  _buildHistoricItem(),
                  _buildHistoricItem(),
                ],
              ),
            ),
            Positioned(
              bottom: 0 + Get.mediaQuery.padding.bottom,
              left: 0,
              right: 0,
              child: Container(
                height: 130,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildListViewItem(
                        text: "Meus contatos",
                        route: Routes.FRIENDSHIPLIST,
                        icon: Icons.person_add),
                    _buildListViewItem(
                        text: "Meus grupos",
                        route: Routes.USER_GROUP,
                        icon: Icons.group_add),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
