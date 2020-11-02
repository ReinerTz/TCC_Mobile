import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tcc_project/pages/profile_udpate/profile_update_controller.dart';
import 'package:tcc_project/routes/app_routes.dart';
import 'package:tcc_project/widgets/default_loading_widget.dart';

class ProfileUpdatePage extends GetWidget<ProfileUpdateController> {
  final profileUpdateController = Get.find<ProfileUpdateController>();
  @override
  Widget build(BuildContext context) {
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
                        child: TextFormField(
                          onChanged: profileUpdateController.setValue,
                          initialValue: profileUpdateController.value.value,
                        ),
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
                      onPressed: () async {
                        var response = await profileUpdateController.save();
                        if (response) {
                          Get.offAllNamed(Routes.PROFILE, arguments: {
                            "user": profileUpdateController.user
                          });
                        }
                      }),
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
