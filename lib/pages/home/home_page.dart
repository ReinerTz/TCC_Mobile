import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tcc_project/pages/home/home_controller.dart';
import 'package:tcc_project/widgets/appbar_widget.dart';
import 'package:tcc_project/widgets/drawer_widget.dart';

class HomePage extends GetWidget<HomeController> {
  @override
  Widget build(BuildContext context) {
    Widget _buildCard(String text) {
      return InkWell(
        onTap: () {},
        child: Card(
          color: Theme.of(context).primaryColor,
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
          drawer: DrawerWidget(Get.find<HomeController>().user, 0),
          body: GridView.count(
            crossAxisCount: 2,
            children: [
              _buildCard("Faça uma vaquinha"),
              _buildCard("Meu histórico\nde gastos"),
              _buildCard("Crie\nou\nparticipe\nde um grupo"),
              _buildCard("Adicione contatos"),
              _buildCard("Meus grupos"),
              _buildCard("Quem somos nós?"),
            ],
          )),
    );
  }
}
