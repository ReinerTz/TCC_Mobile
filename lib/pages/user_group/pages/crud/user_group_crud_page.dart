import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tcc_project/common/constants.dart';
import 'package:tcc_project/models/expense_model.dart';
import 'package:tcc_project/pages/user_group/pages/crud/user_group_crud_controller.dart';
import 'package:tcc_project/routes/app_routes.dart';

class UserGroupCrudPage extends GetWidget<UserGroupCrudController> {
  final ugcc = Get.find<UserGroupCrudController>();
  final textEditing = TextEditingController();
  final editTitle = TextEditingController();
  final editDescription = TextEditingController();
  final pageController = PageController(initialPage: 0);
  final _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    Widget _buildImage() {
      return Obx(() {
        if ((ugcc.avatar.value == null) || (ugcc.avatar.value.isEmpty)) {
          return GestureDetector(
            onTap: () async {
              PickedFile image =
                  await _picker.getImage(source: ImageSource.gallery);
              if (image != null) {
                ugcc.updateProfileImage(File(image.path));
              }
            },
            child: CircleAvatar(
              backgroundImage: AssetImage(AssetImages.GROUP),
              backgroundColor: Colors.white,
              radius: 55,
            ),
          );
        }

        return GestureDetector(
          onTap: () async {
            PickedFile image =
                await _picker.getImage(source: ImageSource.gallery);
            if (image != null) {
              ugcc.updateProfileImage(File(image.path));
            }
          },
          child: CircleAvatar(
            backgroundImage: NetworkImage(ugcc.avatar.value),
            backgroundColor: Colors.white,
            radius: 55,
          ),
        );
      });
    }

    Widget _buildUserAvatar({String image = ""}) {
      return Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.fill,
            image: image.isEmpty
                ? AssetImage(AssetImages.AVATAR)
                : NetworkImage(image),
          ),
        ),
      );
    }

    Widget _buildPeoples() {
      return Column(
        children: ugcc.peoples.map((data) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: ListTile(
                leading: _buildUserAvatar(
                    image: data["user"] == null
                        ? ""
                        : data["user"]["avatar"] ?? ""),
                title: data["user"] != null
                    ? Text(data["user"]["name"])
                    : Text("Anônimo ${data["id"]}"),
                subtitle: Text(
                    "R\$ ${ugcc.getTotalByPeople(data["id"]).toStringAsFixed(2)}"),
                trailing: ((ugcc.isAdmin) &&
                        ((data["user"] == null) ||
                            (data["user"]["uid"] != ugcc.user.uid)))
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.red,
                        ),
                        onPressed: () => ugcc.deleteUserGroup(data),
                      )
                    : null,
              ),
            ),
          );
        }).toList(),
      );
    }

    Widget _buildExpenses() {
      return Column(
        children: ugcc.expenses.map((data) {
          return Card(
            child: InkWell(
              onTap: () async {
                dynamic peoples = await ugcc.getUserExpense(data);
                Get.toNamed(Routes.CRUD_EXPENSES, arguments: {
                  "user": ugcc.user.toMap(),
                  "peoples": peoples,
                  "expense": ExpenseModel.fromMap(data),
                });
              },
              child: ListTile(
                title: Text(data["title"]),
                subtitle: Text(
                    "R\$ ${(data["price"].toDouble() * data["quantity"].toDouble()).toStringAsFixed(2)}"),
                trailing: ((ugcc.isAdmin) ||
                        ((data["createdBy"] != null) &&
                            (data["createdBy"]["uid"] == ugcc.user.uid)))
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.red,
                        ),
                        onPressed: () => ugcc.deleteExpense(data),
                      )
                    : null,
              ),
            ),
          );
        }).toList(),
      );
    }

    _buildDialog() {
      double totalExpenses = ugcc.getTotalExpenses();
      double totalSplit = ugcc.getTotalSplit();
      double myTotal = ugcc.getMyTotal();
      List lst = ugcc.getMyExpenses();
      Get.dialog(Card(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Text(
                  "Resumo",
                  style: GoogleFonts.roboto(
                      fontSize: 26, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: EdgeInsets.only(left: 40),
                child: Text(
                  "Valor das despesas: R\$ ${totalExpenses.toStringAsFixed(2)}",
                  style: GoogleFonts.roboto(fontSize: 16),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 40),
                child: Text(
                  "Valor pago por pessoa: R\$ ${totalSplit.toStringAsFixed(2)}",
                  style: GoogleFonts.roboto(fontSize: 16),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 40),
                child: Text(
                  "Diferença: R\$ ${(totalSplit - totalExpenses).toStringAsFixed(2)}",
                  style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: (totalSplit - totalExpenses) < 0
                          ? Colors.red
                          : (totalSplit - totalExpenses) > 0
                              ? Colors.green
                              : Colors.black),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: EdgeInsets.only(left: 40),
                child: Text(
                  "Total a pagar: R\$ ${myTotal.toStringAsFixed(2)}",
                  style: GoogleFonts.roboto(
                    fontSize: 24,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Column(
                  children: lst.map((data) {
                return Card(
                  elevation: 3,
                  child: ListTile(
                    title: Text(data["expense"]["title"]),
                    trailing: Text(
                      "R\$ ${data["price"].toStringAsFixed(2)}",
                      style: GoogleFonts.roboto(fontSize: 20),
                    ),
                  ),
                );
              }).toList())
            ],
          ),
        ),
      ));

      // double totalExpenses = ugcc.getTotalExpenses();
      //                 double totalSplit = ugcc.getTotalSplit();

      //                return Get.defaultDialog(
      //                   content: Column(
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [
      //                       Text(
      //                           "Total das despesas: R\$ ${totalExpenses.toStringAsFixed(2)}"),
      //                       SizedBox(
      //                         height: 10,
      //                       ),
      //                       Text(
      //                           "Valor total rateado: R\$ ${totalSplit.toStringAsFixed(2)}"),
      //                       SizedBox(
      //                         height: 10,
      //                       ),
      //                       Text(
      //                           "Diferença: R\$${(totalSplit - totalExpenses).toStringAsFixed(2)}"),
      //                     ],
      //                   ),
      //                   title: "Resumo das despesas",
      //                   confirm: FlatButton(
      //                     color: Get.theme.primaryColor,
      //                     child: Text("Ok"),
      //                     onPressed: () {
      //                       Get.back();
      //                     },
      //                   ),
      //                 );
    }

    return Scaffold(
      backgroundColor: Get.theme.primaryColor,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8),
              // child: Text("Totalizador: "),
              child: FlatButton(
                color: Get.theme.primaryColor,
                child: Text("Resumo"),
                onPressed: () {
                  _buildDialog();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: MaterialButton(
                color: Colors.grey,
                onPressed: () => null,
                child: Text("Finalizar a conta"),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () async {
          if (ugcc.actualScreen.value == Screen.peoples) {
            var result = await ugcc.getFriends();
            Get.toNamed(Routes.CRUD_PEOPLES, arguments: {
              "user": ugcc.user.toMap(),
              "peoples": ugcc.peoples,
              "friends": result,
              "group": ugcc.group.value
            });
          } else {
            Get.toNamed(Routes.CRUD_EXPENSES, arguments: {
              "user": ugcc.user.toMap(),
              "peoples": ugcc.createUserExpense(),
              "expense": ExpenseModel(
                  price: 1,
                  quantity: 1,
                  group: ugcc.group.value,
                  date: DateTime.now()),
            });
          }
        },
        child: Icon(Icons.add, color: Colors.black),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              floating: true,
              backgroundColor: Colors.black54,
              title: Text("Grupo"),
              flexibleSpace: Center(
                child: _buildImage(),
              ),
              bottom: PreferredSize(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ugcc.group.value.title.length > 22
                                  ? ugcc.group.value.title.substring(0, 22) +
                                      "..."
                                  : ugcc.group.value.title,
                              style: GoogleFonts.roboto(
                                  fontSize: 22, color: Colors.white),
                            ),
                            Text(
                              "Criação em: ${DateFormat('dd/MM/yyyy').format(ugcc.group.value.createdAt)}",
                              style: GoogleFonts.roboto(
                                  fontSize: 12, color: Colors.white),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          onPressed: () => Get.toNamed(Routes.CRUD_TITLE,
                              arguments: {"group": ugcc.group.value}),
                        ),
                      ],
                    ),
                  ),
                ),
                preferredSize: Size.fromHeight(175),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Obx(() {
            if (ugcc.isLoading.value) {
              return Container(
                height: Get.mediaQuery.size.height * .5,
                decoration: BoxDecoration(color: Get.theme.primaryColor),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Carregando..."),
                      SizedBox(
                        height: 10,
                      ),
                      LinearProgressIndicator()
                    ],
                  ),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      width: Get.mediaQuery.size.width * .6,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () =>
                                ugcc.actualScreen.value = Screen.peoples,
                            child: Container(
                              decoration:
                                  ugcc.actualScreen.value == Screen.peoples
                                      ? BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      : BoxDecoration(),
                              child: Text(
                                "Pessoas: ${ugcc.peoples.length}",
                                style: GoogleFonts.roboto(
                                    color: Colors.white, fontSize: 19),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () =>
                                ugcc.actualScreen.value = Screen.expenses,
                            child: Container(
                              decoration:
                                  ugcc.actualScreen.value == Screen.expenses
                                      ? BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      : BoxDecoration(),
                              child: Text(
                                "Despesas: ${ugcc.expenses.length}",
                                style: GoogleFonts.roboto(
                                    color: Colors.white, fontSize: 19),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Obx(() {
                    if (ugcc.actualScreen.value == Screen.peoples) {
                      return _buildPeoples();
                    } else {
                      return _buildExpenses();
                    }
                  }),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
