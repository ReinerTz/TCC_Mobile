
import 'package:dio/dio.dart';
import 'package:tcc_project/common/constants.dart';
import 'package:tcc_project/models/user_model.dart';

class UserService {
  Future getUser(String uid) async {
    final dio = Dio();
    try {
      var response = await dio.get(Constants.api + "/user/" + uid);     
      return UserModel.fromMap(response.data);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future getUsers() async {
    Dio dio = Dio();
    return await dio.get(Constants.api + "/users");
  }

  Future saveUser(Map<String, dynamic> params) async {
    final dio = Dio();
    try {    
      return await dio.post("${Constants.api}/user", data: params);
    } catch (e) {
      print(e);
    }
  }
}
