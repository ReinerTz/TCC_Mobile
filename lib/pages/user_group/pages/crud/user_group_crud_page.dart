import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tcc_project/pages/user_group/pages/crud/user_group_crud_controller.dart';
import 'package:tcc_project/widgets/appbar_widget.dart';

class UserGroupCrudPage extends GetWidget<UserGroupCrudController> {
  final ugcc = Get.find<UserGroupCrudController>();
  final textEditing = TextEditingController();
  final editTitle = TextEditingController();
  final editDescription = TextEditingController();
  final pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    Widget _buildPeoples() {
      return Container(
        color: Colors.white,
        child: Obx(() {
          return Container(
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    "Pessoas",
                    style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.person_add,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () => ugcc.addPeople(),
                  ),
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: ugcc.peoples
                        .map(
                          (data) => ListTile(
                            title: Text(data.name),
                          ),
                        )
                        .toList(),
                  ),
                )
              ],
            ),
          );
        }),
      );
    }

    Widget _buildDivisionMethod() {
      return Container(
        color: Colors.white,
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(
                  "Método de divisão",
                  style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: Text("Fixo"),
                leading: Radio(
                  groupValue: ugcc.division.value,
                  value: DivisionOption.fixed,
                  onChanged: ugcc.setDivision,
                ),
              ),
              ListTile(
                title: Text("Percentual"),
                leading: Radio(
                  groupValue: ugcc.division.value,
                  value: DivisionOption.percentage,
                  onChanged: ugcc.setDivision,
                ),
              ),
              ListTile(
                title: Text("Despesa"),
                leading: Radio(
                  groupValue: ugcc.division.value,
                  value: DivisionOption.expense,
                  onChanged: ugcc.setDivision,
                ),
              ),
            ],
          );
        }),
      );
    }

    Widget _buildExpenses() {
      final TextEditingController description = TextEditingController();
      final TextEditingController value = TextEditingController();
      final TextEditingController quantity = TextEditingController();
      return Container(
        color: Colors.white,
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(
                  "Despesas",
                  style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
                ),
                trailing: IconButton(
                    icon: Icon(
                      Icons.playlist_add,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      Get.defaultDialog(
                        title: "Adicionar uma despesa",
                        content: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                controller: description,
                                decoration:
                                    InputDecoration(labelText: "Descrição"),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              TextField(
                                controller: value,
                                decoration: InputDecoration(
                                    labelText: "Preço unidade",
                                    hintText: "0,00"),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              TextField(
                                controller: quantity,
                                decoration: InputDecoration(
                                    labelText: "Quantidade", hintText: "0"),
                              ),
                            ],
                          ),
                        ),
                        confirm: MaterialButton(
                          onPressed: () => ugcc.addExpense(
                              price: double.parse(value.text),
                              quantity: int.parse(quantity.text),
                              title: description.text),
                          color: Colors.green,
                          child: Text("Salvar"),
                        ),
                        cancel: MaterialButton(
                          color: Colors.red,
                          onPressed: () {
                            Get.back();
                          },
                          child: Text("Fechar"),
                        ),
                      );
                    }),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: ugcc.expenses
                    .map<Widget>(
                      (data) => InkWell(
                        child: ListTile(
                          title: Text(data.title),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Valor unitário: ${data.price.toStringAsFixed(2)}"),
                              Text("Quantidade: ${data.quantity}"),
                              Text(
                                  "Valor total: ${(data.quantity * data.price).toStringAsFixed(2)}")
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              ugcc.expenses.remove(data);
                            },
                            color: Colors.red,
                          ),
                        ),
                        onTap: () {
                          description.text = data.title;
                          value.text = data.price.toString();
                          quantity.text = data.quantity.toString();
                          Get.defaultDialog(
                            title: "Editar uma despesa",
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  controller: description,
                                  decoration:
                                      InputDecoration(labelText: "Descrição"),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                TextField(
                                  keyboardType: TextInputType.number,
                                  controller: value,
                                  decoration: InputDecoration(
                                      labelText: "Preço unidade",
                                      hintText: "0,00"),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                TextField(
                                  keyboardType: TextInputType.number,
                                  controller: quantity,
                                  decoration: InputDecoration(
                                      labelText: "Quantidade", hintText: "0"),
                                ),
                              ],
                            ),
                            confirm: MaterialButton(
                              onPressed: () {
                                data.price = double.parse(value.text);
                                data.quantity = int.parse(quantity.text);
                                data.title = description.text;
                                Get.back();
                              },
                              color: Colors.green,
                              child: Text("Salvar"),
                            ),
                            cancel: MaterialButton(
                              color: Colors.red,
                              onPressed: () {
                                Get.back();
                              },
                              child: Text("Fechar"),
                            ),
                          );
                        },
                      ),
                    )
                    .toList(),
              )
            ],
          );
        }),
      );
    }

    Widget _buildTitleAndDescription() {
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Título",
              style:
                  GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: editTitle,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Descrição",
              style:
                  GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: editDescription,
              keyboardType: TextInputType.multiline,
              maxLines: 6,
              maxLength: 50,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildButton({Widget widget, bool condition, Widget response}) {
      if (condition) {
        return response;
      }

      return widget;
    }

    Widget _buildPriorAndNext() {
      return Obx(() {
        pageController.addListener(() {
          if (pageController.page.round() != ugcc.currentIndex.value) {
            ugcc.currentIndex.value = pageController.page.round();
          }
        });

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildButton(
                  widget: OutlineButton(
                    child: Text("Anterior"),
                    onPressed: () => pageController
                        .jumpToPage(pageController.page.round() - 1),
                  ),
                  condition: ugcc.currentIndex.value == 0,
                  response: Container()),
              _buildButton(
                widget: OutlineButton(
                  child: Text("Próximo"),
                  onPressed: () => pageController
                      .jumpToPage(pageController.page.round() + 1),
                ),
                condition: ugcc.currentIndex.value == 3,
                response: OutlineButton(
                  child: Text("CRIAR GRUPO"),
                  onPressed: () async {
                    var response = await ugcc.saveGroup(
                        editTitle.text, editDescription.text);
                    if (response) {
                      Get.back();
                    }
                  },
                ),
              ),
            ],
          ),
        );
      });
    }

    Widget _buildWidgetButton(Widget param) {
      return Stack(
        children: [
          Positioned(
            top: 0,
            height: Get.mediaQuery.size.height * .85,
            left: 0,
            right: 0,
            child: param,
          ),
          Positioned(
            bottom: Get.mediaQuery.padding.bottom,
            left: 0,
            right: 0,
            child: _buildPriorAndNext(),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBarWidget(),
      body: PageView(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          _buildWidgetButton(_buildTitleAndDescription()),
          _buildWidgetButton(_buildExpenses()),
          _buildWidgetButton(_buildDivisionMethod()),
          _buildWidgetButton(_buildPeoples()),
        ],
      ),
    );
  }
}
