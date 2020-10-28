import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tcc_project/common/constants.dart';
import 'package:tcc_project/pages/user_group/pages/crud_expenses/crud_expenses_controller.dart';
import 'package:tcc_project/widgets/appbar_widget.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class CrudExpensesPage extends GetView<CrudExpensesController> {
  final moneyMask = new MoneyMaskedTextController();
  final df = DateFormat("dd/MM/yyyy");

  @override
  Widget build(BuildContext context) {
    final mask = new MoneyMaskedTextController(
        initialValue: controller.expense.value.price ?? 0);
    final _dateControl =
        TextEditingController(text: df.format(controller.expense.value.date));

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

    Widget _buildExpense() {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: controller.expense.value.title,
                maxLength: 50,
                onChanged: controller.setTitle,
                decoration: InputDecoration(
                    labelText: "Título",
                    hintText: "ex: Chá de boldo",
                    counterText: ""),
              ),
              TextFormField(
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
                initialValue: controller.expense.value.quantity.toString(),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Quantidade"),
                onChanged: (value) {
                  controller.setQuantity(int.tryParse(value));
                },
              ),
              Container(
                padding: EdgeInsets.only(top: 15),
                child: Text(
                    "Valor total: ${(controller.expense.value.price * controller.expense.value.quantity).toStringAsFixed(2)}"),
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildSplitExpenses() {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Formato de divisão"),
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
                  onChanged: (value) => null,
                  value: true,
                  title: Row(
                    children: [
                      Container(
                        width: 150,
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
                          width: 150,
                          child: Text(
                            controller.peoples[index]["user"] != null
                                ? controller.peoples[index]["user"]["name"]
                                : "Anônimo ${controller.peoples[index]["id"]}",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        Container(
                          width: 40,
                          child: TextField(
                            textAlign: TextAlign.end,
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
                            textAlign: TextAlign.end,
                            keyboardType: TextInputType.number,
                            controller: controller.editsPrice[index],
                            style: TextStyle(fontSize: 13),
                            decoration: InputDecoration(counterText: ""),
                          ),
                        ),
                      ],
                    ),
                    value: true,
                    onChanged: (value) => null,
                  ),
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
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          color: Get.theme.primaryColor,
          width: double.infinity,
          child: MaterialButton(
            child: Text(
              "Salvar",
              style: GoogleFonts.roboto(fontSize: 20, color: Colors.white),
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
                child: CircularProgressIndicator(),
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
