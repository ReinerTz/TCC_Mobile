import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:get/get.dart';
import 'package:tcc_project/models/expense_model.dart';
import 'package:tcc_project/models/user_model.dart';
import 'package:tcc_project/services/expense_service.dart';

class CrudExpensesController extends GetxController {
  UserModel user;
  RxBool loading = false.obs;
  ExpenseService _service = ExpenseService();
  Rx<ExpenseModel> expense = ExpenseModel().obs;
  RxList<dynamic> peoples = <dynamic>[].obs;
  RxDouble price = 0.0.obs;
  RxInt quantity = 0.obs;
  List editsPrice;
  List editsPercent;

  CrudExpensesController({Map pageArgs}) {
    this.user = UserModel.fromMap(pageArgs["user"]);
    this.peoples = pageArgs["peoples"];
    this.expense.value = pageArgs["expense"];
    price.value = this.expense.value.price;
    quantity.value = this.expense.value.quantity;
    editsPrice = List.generate(
        this.peoples.length, (index) => new MoneyMaskedTextController());
    editsPercent = List.generate(
        this.peoples.length, (index) => new MoneyMaskedTextController());
  }

  void setTitle(String value) => this.expense.value.title = value;
  void setPrice(double value) {
    this.expense.value.price = value;
  }

  void setDate(DateTime value) => this.expense.value.date = value;
  void setQuantity(int value) {
    this.expense.value.quantity = value;
  }

  double get total => (this.expense.value.quantity * this.expense.value.price);

  Future save() async {
    this.loading.value = true;
    try {
      var result = await _service.saveExpense(this.expense.value.toMap());
      print(result);
    } finally {
      this.loading.value = false;
    }
  }
}
