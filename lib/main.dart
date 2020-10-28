import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:tcc_project/bindings/login/login_binding.dart';
import 'package:tcc_project/routes/app_pages.dart';
import 'package:tcc_project/routes/app_routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale("pt")],
      getPages: AppPages.routes,
      initialRoute: Routes.INITIAL,
      defaultTransition: Transition.native,
      navigatorKey: Get.key,
      title: 'DVDR',
      initialBinding: LoginBinding(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color.fromARGB(255, 173, 133, 242),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
