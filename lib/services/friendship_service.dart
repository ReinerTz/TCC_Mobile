import 'dart:collection';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:tcc_project/common/constants.dart';
import 'package:tcc_project/models/friendship_model.dart';
import 'package:tcc_project/models/user_model.dart';

class FriendShipService {
  final dio = Dio();

  Future findById(String uid) async {
    try {
      return await dio.get("${Constants.api}/friend/$uid");
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<Response> getFriendship(UserModel fromUser, UserModel toUser) async {
    List<dynamic> users = List();
    try {
      users.add(fromUser.toMap());
      users.add(toUser.toMap());
      return await dio.post("${Constants.api}/find-friendship", data: users);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<bool> sendInvite(UserModel fromUser, UserModel toUser) async {
    // 1 - Verifica se já não existe esse invite.
    var response = await getFriendship(fromUser, toUser);
    if (response.statusCode == 200) {
      if (response.data == null) {
        FriendShipModel from = FriendShipModel(
            user: fromUser, friend: toUser, status: FriendShipStatusEnum.SENT);
        FriendShipModel to = FriendShipModel(
            user: toUser,
            friend: fromUser,
            status: FriendShipStatusEnum.RECEIVED);

        // 2 - Cria um registro no fromUser como SENT e no toUser como RECEIVED
        await dio.post("${Constants.api}/friend", data: from.toMap());
        await dio.post("${Constants.api}/friend", data: to.toMap());
        return true;
      }
    }
    return false;
  }

  Future sendAcceptInvate(UserModel fromUser, UserModel toUser) async {
    var response = await getFriendship(fromUser, toUser);
    if (response.statusCode == 200) {
      try {
        for (var item in (response.data as List)) {
          FriendShipModel model = FriendShipModel.fromMap(item);
          model.status = FriendShipStatusEnum.ACCEPT;
          await dio.post("${Constants.api}/friend", data: model.toMap());
        }
      } catch (error) {
        print(error);
        throw error;
      }
    }
    // 1 - Pega todos os registros em que tenha o toUser e o fromUser e seta como ACCEPT
  }

  Future sendRejectInvate(UserModel fromUser, UserModel toUser) async {
    // 1 - Exclui todos os registros que estão como toUser e fromUser
    var response = await getFriendship(fromUser, toUser);
    if (response.statusCode == 200) {
      try {
        (response.data as List).forEach((element) async {
          FriendShipModel model = FriendShipModel.fromMap(element);
          await dio.delete("${Constants.api}/friend", data: model.toMap());
        });
      } catch (error) {
        print(error);
        throw error;
      }
    }
  }
}
