import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tcc_project/common/constants.dart';
import 'package:tcc_project/pages/user_group/pages/crud/user_group_crud_controller.dart';

class UserGroupCrudPage extends GetWidget<UserGroupCrudController> {
  final ugcc = Get.find<UserGroupCrudController>();
  final textEditing = TextEditingController();
  final editTitle = TextEditingController();
  final editDescription = TextEditingController();
  final pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    Widget _buildImage() {
      return CircleAvatar(
        backgroundImage: AssetImage(AssetImages.GROUP),
        backgroundColor: Colors.white,
        radius: 55,
      );
    }

    Widget _buildPeoples() {
      return Column(
        children: [
          Card(
            child: ListTile(
              title: Text("teste"),
            ),
          ),
        ],
      );
    }

    Widget _buildExpenses() {
      return Column(
        children: [
          Card(
            child: ListTile(
              title: Text("testando"),
            ),
          )
        ],
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
                child: GestureDetector(
                  onTap: () => null,
                  child: _buildImage(),
                ),
              ),
              bottom: PreferredSize(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Grupo de alimentos",
                            style: GoogleFonts.roboto(
                                fontSize: 22, color: Colors.white),
                          ),
                          Text(
                            "Criação em: 20/20/2000",
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
                        onPressed: () => null,
                      ),
                    ],
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
