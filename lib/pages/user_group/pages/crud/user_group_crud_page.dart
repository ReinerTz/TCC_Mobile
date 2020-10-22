import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tcc_project/common/constants.dart';
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
        if (ugcc.isLoading.value) {
          return Container(
            height: MediaQuery.of(context).size.width,
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Carregando foto..."),
                  SizedBox(
                    height: 10,
                  ),
                  CircularProgressIndicator()
                ],
              ),
            ),
          );
        }

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

    Widget _buildPeoples() {
      return Column(
        children: ugcc.peoples
            .map(
              (data) => Card(
                child: ListTile(
                  title: Text(data["user"]["name"]),
                ),
              ),
            )
            .toList(),
      );
    }

    Widget _buildExpenses() {
      return Column(
        children: ugcc.expenses
            .map(
              (data) => Card(
                child: ListTile(
                  title: Text(data["title"]),
                ),
              ),
            )
            .toList(),
      );
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
              child: Text("Totalizador: "),
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
        onPressed: () => null,
        child: Icon(Icons.add),
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
                              ugcc.group.value.title,
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
          child: Obx(
            () => Padding(
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
                                "Pessoas",
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
                                "Despesas",
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
                  Builder(builder: (c) {
                    if (ugcc.actualScreen.value == Screen.peoples) {
                      return _buildPeoples();
                    } else {
                      return _buildExpenses();
                    }
                  }),
                  // Column(
                  //   children: [
                  //     Card(
                  //       child: ListTile(
                  //         title: Text("teste"),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
