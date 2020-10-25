import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcc_project/pages/user_group/pages/crud_expenses/crud_expenses_controller.dart';
import 'package:tcc_project/widgets/appbar_widget.dart';

class CrudExpensesPage extends GetWidget<CrudExpensesController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: "Despesas do grupo",
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(),
    );
  }
}
