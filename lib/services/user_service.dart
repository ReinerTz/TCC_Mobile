import 'package:dio/dio.dart';
import 'package:tcc_project/common/constants.dart';
import 'package:tcc_project/models/user_model.dart';

class UserService {
  final dio = Dio();
  Future getUser(String uid) async {
    try {
      var response = await dio.get(Constants.api + "/user/" + uid);
      return UserModel.fromMap(response.data);
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
}
