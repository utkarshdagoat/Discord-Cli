import 'dart:io';
import 'package:discordcli/models/User.dart';
import 'package:discordcli/queryApi/BaseApi.dart';
import 'package:discordcli/logger/log.dart';
import 'package:discordcli/sql/get_params.dart';

class GetByParams extends BaseApi {
  static Future<Map<dynamic, dynamic>> getUserByUsername(
      {required String username}) async {
    Map<String, dynamic> params = {"username": username};
    try {
      final response = await BaseApi.db
          .query(sql: SqlGetByParams.USERBYUSERNAME, values: params);
      if (response.isEmpty) {
        print("Oh You're new here Register first");
        print("Don't worry we will try to remember you after this");
        await User.register();
        print("start once again for validation");
        exit(10);
      } else {
        return {"user": User.fromList(response), "id": response[0][0]};
      }
    } catch (e) {
      Logs.logger.err(e.toString());
      print("Validation Error");
      exit(3);
    }
  }

  static Future<Map<dynamic, dynamic>> getUserByUsernameForDm(
      {required String username}) async {
    Map<String, dynamic> params = {"username": username};
    try {
      final response = await BaseApi.db
          .query(sql: SqlGetByParams.USERBYUSERNAME, values: params);
      if (response.isEmpty) {
        print('No such person exits');
        exit(10);
      } else {
        return {"user": User.fromList(response), "id": response[0][0]};
      }
    } catch (e) {
      Logs.logger.err(e.toString());
      print("Validation Error");
      exit(3);
    }
  }

  static Future<int> getServerByServerName({required String serverName}) async {
    Map<String, dynamic> params = {"server_name": serverName};
    try {
      final response = await BaseApi.db
          .query(sql: SqlGetByParams.IDBYSERVERNAME, values: params);
      if (response.isEmpty) {
        print("Invalid Server Name");
        exit(10);
      }
      return response[0][0];
    } catch (e) {
      Logs.logger.err(e.toString());
      exit(10);
    }
  }

  static Future<dynamic> getChannelByName(
      {required String channelName, required String serverName}) async {
    Map<String, dynamic> params = {
      "channel_name": channelName,
      "server_name": serverName
    };
    try {
      final response = await BaseApi.db
          .query(sql: SqlGetByParams.channelBychannelName, values: params);
      if (response.isEmpty) {
        print("Invalid Channel Name or Server name please check again");
        exit(10);
      }
      return response;
    } catch (e) {
      Logs.logger.err(e.toString());
      exit(10);
    }
  }

  static Future<String> getUsernameByUserId({required int userId}) async {
    Map<String, dynamic> params = {"id": userId};
    try {
      final response = await BaseApi.db
          .query(sql: SqlGetByParams.userNameById, values: params);
      if (response.isEmpty) {
        print("Invalid userId");
        exit(10);
      }
      return response[0][0];
    } catch (e) {
      Logs.logger.err(e.toString());
      exit(10);
    }
  }

  static Future<int> getServerIdByServerName(
      {required String serverName}) async {
    Map<String, dynamic> params = {"server_name": serverName};
    try {
      final response = await BaseApi.db
          .query(sql: SqlGetByParams.serverByserverName, values: params);
      if (response.isEmpty) {
        print("Invalid userId");
        exit(10);
      }
      return response[0][0];
    } catch (e) {
      Logs.logger.err(e.toString());
      exit(10);
    }
  }
}
