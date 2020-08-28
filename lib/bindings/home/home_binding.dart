import 'package:get/get.dart';
import 'package:tcc_project/pages/home/home_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController(pageArgs: Get.arguments));
  }
}
