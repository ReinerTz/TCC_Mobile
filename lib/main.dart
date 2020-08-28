import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcc_project/bindings/login/login_binding.dart';
import 'package:tcc_project/pages/login/login_page.dart';
import 'package:tcc_project/routes/app_pages.dart';
import 'package:tcc_project/routes/app_routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: AppPages.routes,
      initialRoute: Routes.INITIAL,
      defaultTransition: Transition.native,
      navigatorKey: Get.key,
      title: 'DVDR',
      initialBinding: LoginBinding(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color.fromARGB(255, 247, 224, 136),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }
}
