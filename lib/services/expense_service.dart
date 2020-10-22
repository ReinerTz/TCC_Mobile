import 'package:dio/dio.dart';
import 'package:tcc_project/common/constants.dart';

class ExpenseService {
  final dio = Dio();

  Future saveExpense(Map<String, dynamic> params) async {
    try {
      return await dio.post("${Constants.api}/expense", data: params);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future getByGroup(dynamic id) async {
    try {
      return await dio.get("${Constants.api}/expense/group/$id");
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
