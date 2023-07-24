import 'dart:io';
import 'package:discordcli/models/Session.dart';
import 'package:discordcli/models/User.dart';
import 'package:discordcli/models/channels.dart';
import 'package:discordcli/queryApi/BaseApi.dart';
import 'package:discordcli/queryApi/get_params.dart';
import 'package:discordcli/logger/log.dart';
import 'package:discordcli/sql/create.dart';
import 'package:discordcli/sql/delete.dart';

class Create extends BaseApi {
  Create._();
  static Future<User> createUser(dynamic data) async {
    User user = User.fromMap(data);
    String sql = sqlCreate.USERS;
    Map<String, dynamic> params = {
      "username": user.getUsername,
      "password": User.hashPwd(pass: user.getPass),
    };
    try {
      await BaseApi.db.query(sql: sql, values: params);
    } catch (e) {
      Logs.logger.err(e.toString());
    }

    return user;
  }

  static Future<Session> createSession({required int user_id}) async {
    Session session = Session(user_id: user_id);
    String sql = sqlCreate.SESSIONS;

    Map<String, dynamic> params = {
      "sessionkey": session.sessionKey,
      "user_id": session.user_id,
    };
    try {
      await BaseApi.db.query(sql: sql, values: params);
    } catch (e) {
      Logs.logger.err(e.toString());
      exit(2);
    }

    return session;
  }

  static Future<void> createServer(
      {required int userId, required String serverName}) async {
    Map<String, dynamic> params = {
      "server_name": serverName,
      "owner_id": userId,
    };
    try {
      await BaseApi.db.query(sql: sqlCreate.SERVERS, values: params);
      return;
    } catch (e) {
      Logs.logger.err(e.toString());
      return;
    }
  }

  static Future<dynamic> joinServer(
      {required int userId, required String serverName}) async {
    Map<String, dynamic> params = {
      "server_id":
          await GetByParams.getServerIdByServerName(serverName: serverName),
      "server_name": serverName,
      "user_id": userId,
    };
    try {
      final response =
          await BaseApi.db.query(sql: sqlCreate.SERVER_USERS, values: params);
      return response;
    } catch (e) {
      Logs.logger.err(e.toString());
    }
  }

  static Future<void> addMod(
      {required String serverName, required String username}) async {
    try {
      final modId =
          (await GetByParams.getUserByUsername(username: username))["id"];
      Map<String, dynamic> params = {
        "server_id":
            await GetByParams.getServerIdByServerName(serverName: serverName),
        "server_name": serverName,
        "mod_id": modId,
      };
      await BaseApi.db.query(sql: sqlCreate.SERVER_MODS, values: params);
      await BaseApi.db
          .query(sql: DeleteSql.deleteServerUserRelation, values: params);
    } catch (e) {
      Logs.logger.err(e.toString());
    }
  }

  static Future<void> createChannel(
      {required int userId,
      required int categoryId,
      required String channelName,
      required channelType channelType}) async {
    final Map<String, dynamic> params = {
      "channel_name": channelName,
      "channel_type": channelType.toString(),
      "category_id": categoryId
    };
    try {
      final response =
          await BaseApi.db.query(sql: sqlCreate.CHANNELS, values: params);
      if (response.isNotEmpty) {
        Logs.logger.success('\n $channelName succefully created');
      }
    } catch (e) {
      Logs.logger.err(e.toString());
    }
  }

  static Future<void> createChannelMessage(
      {required String messageText,
      required int channelId,
      required int userId}) async {
    String sql = sqlCreate.CHANNELS_MESSAGE;
    final Map<String, dynamic> params = {
      "channel_id": channelId,
      "sender": userId,
      "message": messageText
    };
    try {
      await BaseApi.db.query(sql: sql, values: params);
      print("Message sent");
    } catch (e) {
      Logs.logger.err(e.toString());
    }
  }

  static Future<void> createDmMessage(
      {required String messageText,
      required int sender,
      required String toSendUsername}) async {
    final user =
        await GetByParams.getUserByUsernameForDm(username: toSendUsername);
    final Map<String, dynamic> params = {
      "to_send": user["id"],
      "sender": sender,
      "message": messageText
    };
    try {
      await BaseApi.db.query(sql: sqlCreate.DM_MESSAGE, values: params);
      print("Message sent");
    } catch (e) {
      Logs.logger.err(e.toString());
    }
  }

  static Future<int> creatBaseCategory(
      {required String categoryName,
      required int serverId,
      bool isPublic = true}) async {
    final Map<String, dynamic> params = {
      "category_name": categoryName,
      "server_id": serverId,
      "isPublic": isPublic
    };
    try {
      final respose =
          await BaseApi.db.query(sql: sqlCreate.CATEGORY, values: params);
      return respose[0][0];
    } catch (e) {
      print(e);
      exit(11);
    }
  }

  static Future<void> creatProtectedCategory(
      {required int categoryId, required int userId}) async {
    final Map<String, dynamic> params = {
      "category_id": categoryId,
      "user_id": userId
    };
    try {
      await BaseApi.db.query(sql: sqlCreate.CATEGORY_PROTECTED, values: params);
    } catch (e) {
      print(e);
      exit(11);
    }
  }
}
