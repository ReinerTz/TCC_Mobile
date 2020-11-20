import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tcc_project/pages/profile_update/profile_update_controller.dart';
import 'package:tcc_project/utils/util.dart';
import 'package:tcc_project/widgets/default_loading_widget.dart';

class ProfileUpdatePage extends GetWidget<ProfileUpdateController> {
  final profileUpdateController = Get.find<ProfileUpdateController>();
  final df = DateFormat("dd/MM/yyyy");
  @override
  Widget build(BuildContext context) {
    var _control;

    switch (controller.fieldName.value) {
      case "birthday":
        _control = TextEditingController(
          text: df.format(
            profileUpdateController.valueAsDate ?? DateTime.now(),
          ),
        );
        break;
      case "phone":
        _control = MaskedTextController(
            mask: '(00) 00000-0000',
            text: Util.onlyNumbers(profileUpdateController.value.value));
        break;

      default:
        _control = null;
    }

    Widget _buildField() {
      switch (profileUpdateController.fieldName.value) {
        case "birthday":
          return TextFormField(
            readOnly: true,
            controller: _control,
            decoration: InputDecoration(hintText: df.format(DateTime.now())),
            onTap: () async {
              DateTime dtPick = await showDatePicker(
                context: context,
                initialDate: controller.valueAsDate != null
                    ? controller.valueAsDate
                    : DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                locale: Locale("pt"),
              );
              if (dtPick != null) {
                _control.text = df.format(dtPick);
                controller.setValue(dtPick);
              }
            },
          );
        case "phone":
          return TextFormField(
            controller: _control,
            onChanged: profileUpdateController.setValue,
            keyboardType: TextInputType.number,
          );
        case "exclusive_user_name":
          return TextFormField(
              decoration: InputDecoration(hintText: "ex: @Fulaninho"),
              onChanged: profileUpdateController.setValue,
              initialValue: profileUpdateController.value.value);
        default:
          return TextFormField(
            onChanged: profileUpdateController.setValue,
            initialValue: profileUpdateController.value.value,
          );
      }
    }

    return Scaffold(
      //appBar: AppBarWidget(),
      body: Container(
        decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        child: GetX<ProfileUpdateController>(builder: (_) {
          if (profileUpdateController.loading.value) {
            return DefaultLoadingWidget();
          }

          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profileUpdateController.field.value,
                        style: GoogleFonts.roboto(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Theme(
                        data: ThemeData(primaryColor: Colors.black),
                        child: _buildField(),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: OutlineButton(
                    color: Theme.of(context).primaryColor,
                    child: Text("Salvar"),
                    borderSide: BorderSide(
                      color: Colors.black, //Color of the border
                      style: BorderStyle.solid, //Style of the border
                      width: 0.8, //width of the border
                    ),
                    onPressed: () async => await profileUpdateController.save(),
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
