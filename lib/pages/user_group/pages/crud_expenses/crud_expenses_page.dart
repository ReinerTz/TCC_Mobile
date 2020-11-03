import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tcc_project/pages/user_group/pages/crud_expenses/crud_expenses_controller.dart';
import 'package:tcc_project/widgets/appbar_widget.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:tcc_project/widgets/default_loading_widget.dart';

class CrudExpensesPage extends GetView<CrudExpensesController> {
  final moneyMask = new MoneyMaskedTextController();
  final df = DateFormat("dd/MM/yyyy");

  @override
  Widget build(BuildContext context) {
    final mask = new MoneyMaskedTextController(
        initialValue: controller.expense.value.price ?? 0);
    final _dateControl =
        TextEditingController(text: df.format(controller.expense.value.date));

    Widget _buildExpense() {
      return Card(
        child: Obx(() {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  enabled: controller.canChange,
                  initialValue: controller.expense.value.title,
                  maxLength: 50,
                  onChanged: controller.setTitle,
                  decoration: InputDecoration(
                      labelText: "Título",
                      hintText: "ex: Chá de boldo",
                      counterText: ""),
                ),
                TextFormField(
                  enabled: controller.canChange,
                  controller: mask,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    controller.setPrice(
                      double.tryParse(
                        mask.text.replaceAll(".", "").replaceAll(",", "."),
                      ),
                    );
                  },
                  decoration: InputDecoration(
                    labelText: "Valor (R\$)",
                  ),
                ),
                TextFormField(
                  enabled: controller.canChange,
                  readOnly: true,
                  controller: _dateControl,
                  keyboardType: TextInputType.datetime,
                  onTap: () async {
                    DateTime dtPick = await showDatePicker(
                      context: context,
                      initialDate: controller.expense.value.date != null
                          ? controller.expense.value.date
                          : DateTime.now(), //COLOCAR DATA NO BACKEND
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                      locale: Locale("pt"),
                    );
                    if (dtPick != null) {
                      _dateControl.text = df.format(dtPick);
                      controller.expense.value.date = dtPick;
                    }
                  },
                  decoration: InputDecoration(
                      labelText: "Data", hintText: df.format(DateTime.now())),
                ),
                TextFormField(
                  enabled: controller.canChange,
                  initialValue: controller.expense.value.quantity.toString(),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Quantidade"),
                  onChanged: (value) {
                    if (value.isEmpty) {
                      value = "1";
                    }
                    controller.setQuantity(int.tryParse(value));
                  },
                ),
                Container(
                  padding: EdgeInsets.only(top: 15),
                  child: Text(
                      "Valor total: ${controller.total.toStringAsFixed(2)}"),
                ),
              ],
            ),
          );
        }),
      );
    }

    Widget optionButton({void Function() onPressed, Widget child}) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: OutlineButton(
            borderSide: BorderSide(color: Get.theme.primaryColor),
            child: child,
            onPressed: onPressed,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0))),
      );
    }

    Widget _buildSplitExpenses() {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              !controller.canChange
                  ? Container()
                  : Text(
                      "Formato de divisão entre os usuários selecionados",
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w500, fontSize: 16),
                    ),
              !controller.canChange
                  ? Container()
                  : SizedBox(
                      height: 10,
                    ),
              !controller.canChange
                  ? Container()
                  : Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            optionButton(
                                child: Text("Dividir valor restante"),
                                onPressed: !controller.canChange
                                    ? null
                                    : () {
                                        controller.splitRemaining();
                                      }),
                            optionButton(
                                child: Text("Zerar valor"),
                                onPressed: !controller.canChange
                                    ? null
                                    : () {
                                        controller.resetValue();
                                      }),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            optionButton(
                                child:
                                    Text("Dividir somente para selecionados"),
                                onPressed: !controller.canChange
                                    ? null
                                    : () {
                                        controller.splitSelectedOnly();
                                      }),
                          ],
                        ),
                      ],
                    ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                ),
                child: CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: !controller.canChange
                      ? null
                      : (value) => controller.selectAllItems(value),
                  value: controller.selectAll.value,
                  title: Row(
                    children: [
                      Container(
                        width: 130,
                        child: Text(
                          "Nome",
                          style:
                              GoogleFonts.roboto(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        width: 40,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Perc.\n(%)",
                            style:
                                GoogleFonts.roboto(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      Container(width: 20),
                      Container(
                        width: 75,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Valor \n(R\$)",
                            style:
                                GoogleFonts.roboto(fontWeight: FontWeight.w500),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Column(
                children: List.generate(
                  controller.peoples.length,
                  (index) => CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Row(
                        children: [
                          Container(
                            width: 130,
                            child: Text(
                              controller.peoples[index]["userGroup"]["user"] !=
                                      null
                                  ? controller.peoples[index]["userGroup"]
                                      ["user"]["name"]
                                  : "Anônimo ${controller.peoples[index]["userGroup"]["id"]}",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          Container(
                            width: 40,
                            child: TextField(
                              enabled: controller.canChange,
                              textAlign: TextAlign.end,
                              onChanged: (value) {
                                controller.onChangeDynamicPerc(
                                  index,
                                  double.parse(
                                    controller.editsPercent[index].text
                                        .replaceAll(".", "")
                                        .replaceAll(",", "."),
                                  ),
                                );
                              },
                              controller: controller.editsPercent[index],
                              keyboardType: TextInputType.number,
                              style: TextStyle(fontSize: 13),
                              decoration: InputDecoration(counterText: ""),
                              maxLength: 6,
                            ),
                          ),
                          Container(width: 20),
                          Container(
                            width: 75,
                            child: TextField(
                              enabled: controller.canChange,
                              onChanged: (value) {
                                controller.onChangeDynamicPrice(
                                  index,
                                  double.parse(
                                    controller.editsPrice[index].text
                                        .replaceAll(".", "")
                                        .replaceAll(",", "."),
                                  ),
                                );
                              },
                              textAlign: TextAlign.end,
                              keyboardType: TextInputType.number,
                              controller: controller.editsPrice[index],
                              style: TextStyle(fontSize: 13),
                              decoration: InputDecoration(counterText: ""),
                            ),
                          ),
                        ],
                      ),
                      value: controller.peoples[index]["checked"],
                      onChanged: !controller.canChange
                          ? null
                          : (value) => controller.onChangeItem(index, value)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBarWidget(
        title: "Despesas do grupo",
      ),
      bottomNavigationBar: !controller.canChange
          ? null
          : BottomAppBar(
              shape: CircularNotchedRectangle(),
              child: Container(
                color: Get.theme.primaryColor,
                width: double.infinity,
                child: MaterialButton(
                  child: Text(
                    "Salvar",
                    style:
                        GoogleFonts.roboto(fontSize: 20, color: Colors.white),
                  ),
                  onPressed: () async => await controller.save(),
                ),
              ),
            ),
      backgroundColor: Get.theme.primaryColor,
      body: SingleChildScrollView(
        child: Obx(() {
          if (controller.loading.value) {
            return AspectRatio(
              aspectRatio: 0.6,
              child: Center(
                child: DefaultLoadingWidget(),
              ),
            );
          }

          return Column(
            children: [_buildExpense(), _buildSplitExpenses()],
          );
        }),
      ),
    );
  }
}
