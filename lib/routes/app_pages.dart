import 'package:get/get.dart';
import 'package:tcc_project/bindings/home/home_binding.dart';
import 'package:tcc_project/bindings/login/login_binding.dart';
import 'package:tcc_project/bindings/profile/profile_binding.dart';
import 'package:tcc_project/bindings/profile_update/profile_update_binding.dart';
import 'package:tcc_project/pages/home/home_page.dart';
import 'package:tcc_project/pages/login/login_page.dart';
import 'package:tcc_project/pages/profile/profile_page.dart';
import 'package:tcc_project/pages/profile_udpate/profile_update_page.dart';
import 'package:tcc_project/routes/app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.INITIAL,
      page: () => LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => ProfilePage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.PROFILE_UPDATE,
      page: () => ProfileUpdatePage(),
      binding: ProfileUpdateBinding(),
    ),
  ];
}
