import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tcc_project/pages/user_group/pages/crud_title/crud_title_controller.dart';
import 'package:tcc_project/widgets/appbar_widget.dart';

class CrudTitlePage extends GetWidget<CrudTitleController> {
  final ctc = Get.find<CrudTitleController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),
      backgroundColor: Colors.white,
      body: Padding(
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
              onChanged: ctc.setTitle,
              initialValue: ctc?.group?.title ?? "",
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
              onChanged: ctc.setDescription,
              initialValue: ctc?.group?.description ?? "",
              keyboardType: TextInputType.multiline,
              maxLines: 6,
              maxLength: 50,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10),
              width: double.infinity,
              height: 55,
              child: MaterialButton(
                onPressed: () async => await ctc.save(),
                child: Text(
                  "Salvar",
                  style: GoogleFonts.roboto(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                color: Get.theme.primaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
