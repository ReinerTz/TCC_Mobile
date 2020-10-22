import 'package:get/get.dart';
import 'package:tcc_project/bindings/friendship/friendship_binding.dart';
import 'package:tcc_project/bindings/friendshiplist/friendshiplist_binding.dart';
import 'package:tcc_project/bindings/home/home_binding.dart';
import 'package:tcc_project/bindings/login/login_binding.dart';
import 'package:tcc_project/bindings/profile/profile_binding.dart';
import 'package:tcc_project/bindings/profile_update/profile_update_binding.dart';
import 'package:tcc_project/bindings/profile_view/profile_view_binding.dart';
import 'package:tcc_project/bindings/user_group/crud_expenses_binding.dart';
import 'package:tcc_project/bindings/user_group/crud_title_binding.dart';
import 'package:tcc_project/bindings/user_group/user_group_binding.dart';
import 'package:tcc_project/bindings/user_group/user_group_crud_binding.dart';
import 'package:tcc_project/pages/friendshiplist/friendship/friendship_page.dart';
import 'package:tcc_project/pages/friendshiplist/friendshiplist_page.dart';
import 'package:tcc_project/pages/home/home_page.dart';
import 'package:tcc_project/pages/login/login_page.dart';
import 'package:tcc_project/pages/profile/profile_page.dart';
import 'package:tcc_project/pages/profile_udpate/profile_update_page.dart';
import 'package:tcc_project/pages/profile_view/profile_view_page.dart';
import 'package:tcc_project/pages/user_group/pages/crud/user_group_crud_page.dart';
import 'package:tcc_project/pages/user_group/pages/crud_expenses/crud_expenses_page.dart';
import 'package:tcc_project/pages/user_group/pages/crud_title/crud_title_page.dart';
import 'package:tcc_project/pages/user_group/user_group_page.dart';
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
    GetPage(
      name: Routes.FRIENDSHIP,
      page: () => FriendshipPage(),
      binding: FriendshipBinding(),
    ),
    GetPage(
      name: Routes.FRIENDSHIPLIST,
      page: () => FriendshipListPage(),
      binding: FriendshipListBinding(),
    ),
    GetPage(
      name: Routes.USER_GROUP,
      page: () => UserGroupPage(),
      binding: UserGroupBinding(),
    ),
    GetPage(
      name: Routes.USER_GROUP_CRUD,
      page: () => UserGroupCrudPage(),
      binding: UserGroupCrudBinding(),
    ),
    GetPage(
      name: Routes.PROFILEVIEW,
      page: () => ProfileViewPage(),
      binding: ProfileViewBinding(),
    ),
    GetPage(
      name: Routes.CRUD_EXPENSES,
      page: () => CrudExpensesPage(),
      binding: CrudExpensesBinding(),
    ),
    GetPage(
      name: Routes.CRUD_TITLE,
      page: () => CrudTitlePage(),
      binding: CrudTitleBinding(),
    ),
  ];
}
