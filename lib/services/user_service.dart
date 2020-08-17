import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:tcc_project/common/constants.dart';

class UserService {
  Future getUser(String uid) async {
    Dio dio = Dio();
    return await dio.get(Constants.api + "/user/" + uid);
  }

  Future getUsers() async {
    Dio dio = Dio();
    return await dio.get(Constants.api + "/users");
  }

  Future saveUser(Map<String, dynamic> params) async {
    Dio dio = Dio();
    Map<String, String> headers = {"Content-type": "application/json"};
    //print("${Constants.api}/user");
    try {    
      return await dio.post("${Constants.api}/user", data: params);
      // return await http.post(
      //   "${Constants.api}/user",
      //   body: jsonEncode(params),
      //   headers: headers
      // );
    } catch (e) {
      print(e);
    }

    // return await dio.post(
    //   "${Constants.api}/user",
    //   data: data,
    // );
  }
}
