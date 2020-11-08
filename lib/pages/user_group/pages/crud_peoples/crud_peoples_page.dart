import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcc_project/pages/user_group/pages/crud_peoples/crud_peoples_controller.dart';
import 'package:tcc_project/widgets/appbar_widget.dart';
import 'package:tcc_project/widgets/default_loading_widget.dart';

class CrudPeoplesPage extends GetWidget<CrudPeoplesController> {
  final cpc = Get.find<CrudPeoplesController>();
  @override
  Widget build(BuildContext context) {
    Widget _buildTile(dynamic user) {
      return Obx(
        () {
          if (cpc.loading.value) {
            return DefaultLoadingWidget();
          }

          bool find = cpc.peoples
              .where(
                (data) => ((data["user"] != null) &&
                    (data["user"]["uid"] == user["friend"]["uid"])),
              )
              .toList()
              .isNotEmpty;
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: ListTile(
                title: Text(user["friend"]["name"]),
                subtitle: Text(user["friend"]["exclusive_user_name"]),
                trailing: IconButton(
                  icon: Icon(
                    find ? Icons.check : Icons.add,
                    color: Get.theme.primaryColor,
                  ),
                  onPressed: find
                      ? () {
                          Get.defaultDialog(
                            title: "Informação",
                            middleText: "O usuário já foi adicionado no grupo",
                            backgroundColor: Colors.white,
                            confirm: MaterialButton(
                              color: Get.theme.primaryColor,
                              child: Text("Ok"),
                              onPressed: () => Get.back(),
                            ),
                          );
                        }
                      : () {
                          cpc.addPeople(user["friend"]);
                        },
                ),
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBarWidget(
        title: "Adicionar pessoas",
      ),
      backgroundColor: Get.theme.primaryColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: ListTile(
                    title: Text("Adicionar anônimo"),
                    subtitle: Text(
                        "Você pode adicionar pessoas que não possuem o aplicativo. Assim fica mais fácil de dividir a conta :)"),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Get.theme.primaryColor,
                      ),
                      onPressed: () => Get.defaultDialog(
                        title: "Informação",
                        //middleText: "Adicione um apelido para o anônimo",
                        content: Column(
                          children: [
                            Text("Adicione um apelido para o anônimo"),
                            TextField(
                              decoration: InputDecoration(labelText: "Nome"),
                              onChanged: cpc.setAnonimousName,
                            ),
                          ],
                        ),
                        backgroundColor: Colors.white,
                        confirm: MaterialButton(
                          color: Get.theme.primaryColor,
                          child: Text("Ok"),
                          onPressed: () async {
                            Get.back();
                            await cpc.addAnonimous();
                          },
                        ),
                      ),
                      // onPressed: () => ,
                    ),
                  ),
                ),
              ),
              Column(
                children: cpc.friends.map((data) => _buildTile(data)).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
