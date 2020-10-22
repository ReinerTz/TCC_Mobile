import 'package:dio/dio.dart';
import 'package:tcc_project/common/constants.dart';

class UserGroupService {
  final dio = Dio();

  Future<dynamic> save(Map<String, dynamic> params) async {
    try {
      return await dio.post("${Constants.api}/usergroup", data: params);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future findAllUsersByGroup(dynamic group) async {
    try {
      return await dio.get("${Constants.api}/usergroup/group/$group");
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
