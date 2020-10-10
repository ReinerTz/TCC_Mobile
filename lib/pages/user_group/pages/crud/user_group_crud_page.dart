import 'package:carousel_slider/carousel_slider.dart';
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

  @override
  Widget build(BuildContext context) {
    Widget _buildPeopleCount() {
      return Container(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(29.00),
          ),
          child: TextFormField(
            controller: textEditing,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.subdirectory_arrow_left,
                ),
                onPressed: () {
                  ugcc.generateList(
                    int.parse(textEditing.text),
                  );
                },
              ),
              hintText: "Dividir entre quantas pessoas?",
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(29.0),
                ),
              ),
            ),
          ),
        ),
      );
    }

    Widget _buildExpandedTilePeoples() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: Colors.white,
          child: Obx(() {
            return Column(
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
                Column(
                  children: ugcc.peoples
                      .map(
                        (data) => ListTile(
                          title: Text(data.name),
                        ),
                      )
                      .toList(),
                )
              ],
            );
          }),
        ),
      );
    }

    Widget _buildDivisionMethod() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
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
            // return ExpansionTile(
            //   initiallyExpanded: true,
            //   title: Text("Método de divisão das despesas"),
            //   children: [
            //     ListTile(
            //       title: Text("Fixo"),
            //       leading: Radio(
            //         groupValue: ugcc.division.value,
            //         value: DivisionOption.fixed,
            //         onChanged: ugcc.setDivision,
            //       ),
            //     ),
            //     ListTile(
            //       title: Text("Percentual"),
            //       leading: Radio(
            //         groupValue: ugcc.division.value,
            //         value: DivisionOption.percentage,
            //         onChanged: ugcc.setDivision,
            //       ),
            //     ),
            //     ListTile(
            //       title: Text("Despesa"),
            //       leading: Radio(
            //         groupValue: ugcc.division.value,
            //         value: DivisionOption.expense,
            //         onChanged: ugcc.setDivision,
            //       ),
            //     ),
            //   ],
            // );
          }),
        ),
      );
    }

    Widget _buildExpensionTileExpenses() {
      final TextEditingController description = TextEditingController();
      final TextEditingController value = TextEditingController();
      final TextEditingController quantity = TextEditingController();
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
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
            // return ExpansionTile(
            //   backgroundColor: Colors.white,
            //   initiallyExpanded: true,
            //   title: Text("Despesas"),
            //   children: ugcc.expenses
            //       .map<Widget>(
            //         (data) => InkWell(
            //           child: ListTile(
            //             title: Text(data.title),
            //             subtitle: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Text(
            //                     "Valor unitário: ${data.price.toStringAsFixed(2)}"),
            //                 Text("Quantidade: ${data.quantity}"),
            //                 Text(
            //                     "Valor total: ${(data.quantity * data.price).toStringAsFixed(2)}")
            //               ],
            //             ),
            //             trailing: IconButton(
            //               icon: Icon(Icons.delete),
            //               onPressed: () {
            //                 ugcc.expenses.remove(data);
            //               },
            //               color: Colors.red,
            //             ),
            //           ),
            //           onTap: () {
            //             description.text = data.title;
            //             value.text = data.price.toString();
            //             quantity.text = data.quantity.toString();
            //             Get.defaultDialog(
            //               title: "Editar uma despesa",
            //               content: Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   TextField(
            //                     controller: description,
            //                     decoration:
            //                         InputDecoration(labelText: "Descrição"),
            //                   ),
            //                   SizedBox(
            //                     height: 15,
            //                   ),
            //                   TextField(
            //                     keyboardType: TextInputType.number,
            //                     controller: value,
            //                     decoration: InputDecoration(
            //                         labelText: "Preço unidade",
            //                         hintText: "0,00"),
            //                   ),
            //                   SizedBox(
            //                     height: 15,
            //                   ),
            //                   TextField(
            //                     keyboardType: TextInputType.number,
            //                     controller: quantity,
            //                     decoration: InputDecoration(
            //                         labelText: "Quantidade", hintText: "0"),
            //                   ),
            //                 ],
            //               ),
            //               confirm: MaterialButton(
            //                 onPressed: () {
            //                   data.price = double.parse(value.text);
            //                   data.quantity = int.parse(quantity.text);
            //                   data.title = description.text;
            //                   Get.back();
            //                 },
            //                 color: Colors.green,
            //                 child: Text("Salvar"),
            //               ),
            //               cancel: MaterialButton(
            //                 color: Colors.red,
            //                 onPressed: () {
            //                   Get.back();
            //                 },
            //                 child: Text("Fechar"),
            //               ),
            //             );
            //           },
            //         ),
            //       )
            //       .toList()
            //         ..add(
            //           InkWell(
            //             child: ListTile(
            //               title: Text(
            //                 "Adicionar despesas",
            //                 style:
            //                     GoogleFonts.roboto(fontWeight: FontWeight.bold),
            //               ),
            //             ),
            //             onTap: () {
            //               description.clear();
            //               value.clear();
            //               quantity.clear();
            //               Get.defaultDialog(
            //                 title: "Adicionar uma despesa",
            //                 content: Column(
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     TextField(
            //                       controller: description,
            //                       decoration:
            //                           InputDecoration(labelText: "Descrição"),
            //                     ),
            //                     SizedBox(
            //                       height: 15,
            //                     ),
            //                     TextField(
            //                       controller: value,
            //                       decoration: InputDecoration(
            //                           labelText: "Preço unidade",
            //                           hintText: "0,00"),
            //                     ),
            //                     SizedBox(
            //                       height: 15,
            //                     ),
            //                     TextField(
            //                       controller: quantity,
            //                       decoration: InputDecoration(
            //                           labelText: "Quantidade", hintText: "0"),
            //                     ),
            //                   ],
            //                 ),
            //                 confirm: MaterialButton(
            //                   onPressed: () {
            //                     ugcc.expenses.add(
            //                       ExpenseModel(
            //                           price: double.parse(value.text),
            //                           quantity: int.parse(quantity.text),
            //                           title: description.text),
            //                     );
            //                   },
            //                   color: Colors.green,
            //                   child: Text("Salvar"),
            //                 ),
            //                 cancel: MaterialButton(
            //                   color: Colors.red,
            //                   onPressed: () {
            //                     Get.back();
            //                   },
            //                   child: Text("Fechar"),
            //                 ),
            //               );
            //             },
            //           ),
            //         ),
            // );
          }),
        ),
      );
    }

    _buildDescription() {
      return Container(
        padding: const EdgeInsets.all(8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: TextFormField(
            controller: editDescription,
            keyboardType: TextInputType.multiline,
            maxLines: 6,
            maxLength: 50,
            decoration: InputDecoration(
              hintText: "Descrição do grupo",
              border: OutlineInputBorder(),
            ),
          ),
        ),
      );
    }

    _buildTitle() {
      return Container(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: editTitle,
                  decoration: InputDecoration(
                    hintText: "Titulo do grupo",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              _buildDescription(),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBarWidget(),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: Get.mediaQuery.size.height * 0.824,
            child: CarouselSlider(
              options: CarouselOptions(
                enableInfiniteScroll: false,
                height: Get.mediaQuery.size.height * 0.5,
                autoPlay: false,
              ),
              items: [
                _buildTitle(),
                //_buildDescription(),
                // _buildPeopleCount(),
                _buildExpandedTilePeoples(),
                _buildDivisionMethod(),
                _buildExpensionTileExpenses(),
              ],
            ),
            // child: ListView(
            //   children: [
            //     _buildTitle(),
            //     _buildDescription(),
            //     // _buildPeopleCount(),
            //     _buildExpandedTilePeoples(),
            //     _buildDivisionMethod(),
            //     _buildExpensionTileExpenses(),
            //   ],
            // ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8),
              width: double.infinity,
              child: MaterialButton(
                color: Colors.white,
                onPressed: () {
                  ugcc.saveGroup(editTitle.text, editDescription.text);
                },
                child: Text(
                  "CRIAR",
                  style: GoogleFonts.roboto(
                      fontSize: 23, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
