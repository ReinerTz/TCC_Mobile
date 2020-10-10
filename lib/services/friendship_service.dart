import 'package:dio/dio.dart';
import 'package:tcc_project/common/constants.dart';

class FriendShipService {
  final dio = Dio();

  Future findById(String uid) {
    try {
      var response = dio.get("${Constants.api}/friend/$uid");
      print(response);
      return response;
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
