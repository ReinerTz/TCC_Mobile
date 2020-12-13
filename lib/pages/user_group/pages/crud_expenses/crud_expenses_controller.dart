import 'package:dio/dio.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:get/get.dart';
import 'package:tcc_project/models/expense_model.dart';
import 'package:tcc_project/models/group_model.dart';
import 'package:tcc_project/models/user_model.dart';
import 'package:tcc_project/pages/user_group/pages/crud/user_group_crud_controller.dart';
import 'package:tcc_project/services/expense_service.dart';
import 'package:tcc_project/services/userexpense_service.dart';

class CrudExpensesController extends GetxController {
  final userGroupInstance = Get.find<UserGroupCrudController>();

  UserModel user;
  RxBool loading = false.obs;
  ExpenseService _service = ExpenseService();
  UserExpenseService _serviceUE = UserExpenseService();
  Rx<ExpenseModel> expense = ExpenseModel().obs;
  GroupModel group = GroupModel();
  RxList<dynamic> peoples = <dynamic>[].obs;
  List editsPrice;
  List editsPercent;
  RxBool selectAll = true.obs;
  ExpenseService _expenseService = ExpenseService();

  CrudExpensesController({Map pageArgs}) {
    this.user = UserModel.fromMap(pageArgs["user"]);
    this.peoples.value = pageArgs["peoples"];
    this.expense.value = pageArgs["expense"];
    this.group = GroupModel.fromMap(pageArgs["group"]);

    editsPrice = List.generate(
      this.peoples.length,
      (index) => new MoneyMaskedTextController(
        initialValue: this.peoples[index]["price"] ?? 0,
      ),
    );
    editsPercent = List.generate(
      this.peoples.length,
      (index) => new MoneyMaskedTextController(
        initialValue: this.peoples[index]["percent"] ?? 0,
      ),
    );
    recalculatePrice();
  }

  bool get canChange =>
      (this.group.closed == null || !this.group.closed) &&
      (this
              .peoples
              .where((data) => ((data["userGroup"]["user"] != null) &&
                  (data["userGroup"]["user"]["uid"] == user.uid) &&
                  (data["userGroup"]["admin"])))
              .toList()
              .isNotEmpty ||
          ((this.expense.value.createdBy) != null &&
              (this.expense.value.createdBy.uid == user.uid)) ||
          this.expense.value.id == null);

  double get total => this.expense.value.price * this.expense.value.quantity;
  // dynamic get diference => this.peoples.reduce((total, value) {
  //       return total["price"] ?? 0 + value["price"] ?? 0;
  //     });

  void setTitle(String value) => this.expense.value.title = value;
  void setPrice(double value) {
    this.expense.value.price = value;
    recalculatePrice();
  }

  void setDate(DateTime value) => this.expense.value.date = value;
  void setQuantity(int value) {
    this.expense.value.quantity = value;
    recalculatePrice();
  }

  Future save() async {
    this.loading.value = true;

    try {
      this.expense.value.createdBy = this.user;
      Response result = await _service.saveExpense(this.expense.value.toMap());
      if (result.statusCode == 200) {
        this.peoples.map((data) => data["expense"] = result.data).toList();
        await _serviceUE.saveAll(this.peoples);
      }
      Response response =
          await _expenseService.getByGroup(this.expense.value.group.id);
      if (response.statusCode == 200) {
        this.userGroupInstance.expenses.value = response.data;
        response =
            await _serviceUE.findExpensesbyGroup(this.expense.value.group.id);
        if (response.statusCode == 200) {
          this.userGroupInstance.userExpenses.value = response.data;
        }
      }
    } finally {
      this.loading.value = false;
      Get.back();
    }
  }

  void onChangeDynamicPerc(int index, double value) {
    this.peoples[index]["percent"] = value;
    recalculatePrice();
  }

  void onChangeDynamicPrice(int index, double value) {
    this.peoples[index]["price"] = value;
    recalculatePercent();
  }

  void onChangeItem(int index, bool value) {
    this.peoples[index]["checked"] = value;
    this.peoples.value = List.from(this.peoples);
  }

  void selectAllItems(bool value) {
    this.selectAll.value = value;
    this.peoples.forEach((data) {
      data["checked"] = value;
    });
    this.peoples.value = List.from(this.peoples);
  }

  void resetValue() {
    for (var i = 0; i < this.peoples.length; i++) {
      if (this.peoples[i]["checked"]) {
        this.peoples[i]["percent"] = 0;
        this.peoples[i]["price"] = 0;
        (this.editsPercent[i] as MoneyMaskedTextController).text = "0,00";
        (this.editsPrice[i] as MoneyMaskedTextController).text = "0,00";
      }
    }
    this.peoples.value = List.from(this.peoples);
  }

  void splitRemaining() {
    List notChecked =
        this.peoples.where((element) => element["checked"] == false).toList();
    double remainingValue = this.total;

    if (notChecked.isNotEmpty) {
      for (dynamic value in notChecked) {
        remainingValue -= value["price"];
      }
    }

    remainingValue = remainingValue >= 0 ? remainingValue : 0;
    int peoplesToSplit =
        this.peoples.where((element) => element["checked"]).toList().length;

    String splitPrice = "0";
    String splitPercent = "0";
    if (remainingValue != 0 && peoplesToSplit != 0) {
      splitPrice = (remainingValue / peoplesToSplit).toStringAsFixed(2);
      splitPercent = (((remainingValue / peoplesToSplit) * 100) / total)
          .toStringAsFixed(2);
    }

    for (var i = 0; i < this.peoples.length; i++) {
      if (this.peoples[i]["checked"]) {
        this.peoples[i]["percent"] = double.parse(splitPercent);
        this.peoples[i]["price"] = double.parse(splitPrice);
        (this.editsPercent[i] as MoneyMaskedTextController)
            .updateValue(this.peoples[i]["percent"]);
        (this.editsPrice[i] as MoneyMaskedTextController)
            .updateValue(this.peoples[i]["price"]);
      }
    }
    this.peoples.value = List.from(this.peoples);
  }

  void recalculatePrice() {
    for (var i = 0; i < this.peoples.length; i++) {
      this.peoples[i]["price"] = double.parse(
          (total * (this.peoples[i]["percent"] / 100)).toStringAsFixed(2));

      (this.editsPrice[i] as MoneyMaskedTextController)
          .updateValue(this.peoples[i]["price"]);
    }
    this.peoples.value = List.from(this.peoples);
  }

  void recalculatePercent() {
    for (var i = 0; i < this.peoples.length; i++) {
      this.peoples[i]["percent"] =
          ((this.peoples[i]["price"] * 100) / total).roundToDouble();

      (this.editsPercent[i] as MoneyMaskedTextController)
          .updateValue(this.peoples[i]["percent"]);
    }
    this.peoples.value = List.from(this.peoples);
  }

  void splitSelectedOnly() {
    int peoplesToSplit =
        this.peoples.where((element) => element["checked"]).toList().length;
    for (var i = 0; i < this.peoples.length; i++) {
      if (this.peoples[i]["checked"] == false) {
        this.peoples[i]["percent"] = 0;
        (this.editsPercent[i] as MoneyMaskedTextController).updateValue(0);
      } else {
        this.peoples[i]["percent"] = double.parse(
            (((this.total / peoplesToSplit) * 100) / total).toStringAsFixed(2));
        (this.editsPercent[i] as MoneyMaskedTextController)
            .updateValue(this.peoples[i]["percent"]);
      }
    }
    recalculatePrice();
  }

  double getSumPeoples() {
    double totalValue = 0;
    this.peoples.forEach((value) {
      totalValue += value["price"];
    });

    return totalValue - this.total;
  }
}
