import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcc_project/routes/app_routes.dart';
import 'package:tcc_project/services/userexpense_service.dart';

class CustomListTileWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final int actualPage;
  final int page;
  final String route;
  final Map arguments;

  CustomListTileWidget(
      {@required this.icon,
      @required this.title,
      @required this.actualPage,
      @required this.page,
      @required this.route,
      @required this.arguments});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        if (this.route == Routes.HOME) {
          Response result = await UserExpenseService()
              .findExpensesbyUser(this.arguments["user"]["uid"]);
          this.arguments["userexpenses"] = result.data;
        }

        Get.offAllNamed(this.route, arguments: this.arguments);
      },
      leading: Icon(
        this.icon,
        color: this.actualPage == this.page
            ? Theme.of(context).primaryColor
            : Colors.grey,
      ),
      title: Text(this.title),
    );
  }
}
