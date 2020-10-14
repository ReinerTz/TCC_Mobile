import 'package:dio/dio.dart';
import 'package:tcc_project/common/constants.dart';

class FriendShipService {
  final dio = Dio();

  Future findById(String uid) async {
    try {
      var response = await dio.get("${Constants.api}/friend/$uid");

      print(response);
      return response;
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
