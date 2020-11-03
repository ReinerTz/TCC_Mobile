import 'dart:io';

import 'package:dio/dio.dart';
import 'package:tcc_project/common/constants.dart';

class UserExpenseService {
  final dio = Dio();

  Future<Response> saveAll(List param) async {
    try {
      return await dio.post("${Constants.api}/userexpenses", data: param);
    } catch (error) {
      throw new HttpException("Aconteceu um erro: $error");
    }
  }

  Future<Response> save(Map<String, dynamic> param) async {
    try {
      return await dio.post("${Constants.api}/userexpense", data: param);
    } catch (error) {
      throw new HttpException("Aconteceu um erro: $error");
    }
  }

  Future<Response> delete(Map<String, dynamic> param) async {
    try {
      return await dio.delete("${Constants.api}/userexpense", data: param);
    } catch (error) {
      throw new HttpException("Aconteceu um erro: $error");
    }
  }

  Future<Response> findUserExpenses(int id) async {
    try {
      return await dio.get(
        "${Constants.api}/userexpense/expense/$id",
      );
    } catch (error) {
      throw new HttpException("Aconteceu um erro: $error");
    }
  }

  Future<Response> findExpensesbyGroup(int id) async {
    try {
      return await dio.get(
        "${Constants.api}/userexpense/group/$id",
      );
    } catch (error) {
      throw new HttpException("Aconteceu um erro: $error");
    }
  }

  Future<Response> findExpensesbyUser(String uid) async {
    try {
      return await dio.get(
        "${Constants.api}/userexpense/user/$uid",
      );
    } catch (error) {
      throw new HttpException("Aconteceu um erro: $error");
    }
  }
}
