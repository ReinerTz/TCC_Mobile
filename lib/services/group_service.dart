import 'package:dio/dio.dart';
import 'package:tcc_project/common/constants.dart';
import 'package:tcc_project/models/group_model.dart';

class GroupService {
  final dio = Dio();
  Future saveGroup(Map<String, dynamic> params) async {
    try {
      return await dio.post("${Constants.api}/group", data: params);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future deleteGroup(Map<String, dynamic> params) async {
    try {
      return await dio.delete("${Constants.api}/group", data: params);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<dynamic> findById(int id) async {
    try {
      var response = await dio.get("${Constants.api}/group/$id");
      return GroupModel.fromMap(response.data);
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
