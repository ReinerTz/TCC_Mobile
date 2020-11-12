import 'package:dio/dio.dart';
import 'package:tcc_project/common/constants.dart';

class UserService {
  final dio = Dio();
  Future getUser(String uid) async {
    try {
      return await dio.get(Constants.api + "/user/" + uid);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future getUsers() async {
    return await dio.get(Constants.api + "/users");
  }

  Future saveUser(Map<String, dynamic> params) async {
    try {
      return await dio.post("${Constants.api}/user", data: params);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future getUsersByExclusiveUserName(String name) async {
    try {
      return await dio.get("${Constants.api}/username/$name");
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future getOneUserByExclusiveUserName(String name) async {
    try {
      return await dio.get("${Constants.api}/user/exclusivename/$name");
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
