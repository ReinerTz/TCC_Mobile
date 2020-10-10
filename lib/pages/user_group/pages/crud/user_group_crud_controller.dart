import 'package:get/get.dart';
import 'package:tcc_project/models/expense_model.dart';
import 'package:tcc_project/models/group_model.dart';
import 'package:tcc_project/models/user_model.dart';
import 'package:tcc_project/services/group_service.dart';
import 'package:uuid/uuid.dart';

enum DivisionOption { fixed, percentage, expense }

class UserGroupCrudController extends GetxController {
  UserModel user;
  GroupService _service = GroupService();
  RxList<dynamic> peoples = <dynamic>[].obs;
  RxList<dynamic> expenses = <dynamic>[].obs;

  Rx<DivisionOption> division = DivisionOption.fixed.obs;

  UserGroupCrudController({Map pageArgs}) {
    this.user = pageArgs["user"];
  }

  void setDivision(DivisionOption value) => this.division.value = value;

  void generateList(int qtd) {
    this.peoples.clear();
    this.peoples.value = List.generate(qtd, (index) => index + 1);
  }

  void addPeople() {
    this.peoples.add(
          UserModel(name: "Pessoa ${this.peoples.length + 1}"),
        );
  }

  void addExpense({String title, double price, int quantity}) {
    this.expenses.add(
          ExpenseModel(price: price, title: title, quantity: quantity),
        );
  }

  Future<bool> saveGroup(String title, String description) async {
    GroupModel group = GroupModel();
    //group.createdAt = DateTime.now();
    group.description = description;
    group.sharedKey = Uuid().v1();
    group.title = title;
    group.users = UserModel.fromJsonList(
      this.peoples.where((data) {
        return data.uid != null;
      }).toList(),
    );
    var result = await _service.saveGroup(group.toMap());

    // group.sharedKey = Uuid;
    //_service.saveGroup(params);
  }
}
