import 'dart:io';
import 'package:discordcli/models/Session.dart';
import 'package:discordcli/models/User.dart';
import 'package:discordcli/models/channels.dart';
import 'package:discordcli/models/server.dart';
import 'package:discordcli/queryApi/BaseApi.dart';
import 'package:discordcli/queryApi/get_params.dart';
import 'package:discordcli/queryApi/validation.dart';
import 'package:discordcli/logger/log.dart';

class Create extends BaseApi {
  static Future<User> createUser(dynamic data) async {
    User user = User.fromMap(data);
    String sql = '''
        INSERT INTO users (username , password ) 
        VALUES (@username, @password) returning id
        ''';
    Map<String, dynamic> params = {
      "username": user.username,
      "password": user.hashPwd(pass: user.password),
    };
    try {
      final response = await BaseApi.db.query(sql: sql, values: params);
    } catch (e) {
      Logs.logger.err(e.toString());
    }

    return user;
  }

  static Future<Session> createSession({required int user_id}) async {
    Session session = Session(user_id: user_id);
    String sql = '''
    INSERT INTO sessions (sessionkey , user_id)
    VALUES( @sessionkey , @user_id)
    ''';

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

  static Future<Server> createServer(
      {required int userId, required String serverName}) async {
    Server server = Server(name: serverName, userId: userId);
    String sql = '''
    INSERT INTO servers (server_name , owner_id )
    VALUES (@server_name , @owner_id)
''';
    Map<String, dynamic> params = {
      "server_name": server.serverName,
      "owner_id": server.owner,
    };
    try {
      final response = await BaseApi.db.query(sql: sql, values: params);
    } catch (e) {
      Logs.logger.err(e.toString());
    }
    return server;
  }

  static Future<dynamic> joinServer(
      {required int userId, required String serverName}) async {
    String sql = '''
    INSERT INTO server_users (user_id ,  server_name)
    VALUES (@user_id , @server_name)
''';
    Map<String, dynamic> params = {
      "server_name": serverName,
      "user_id": userId,
    };
    try {
      final response = await BaseApi.db.query(sql: sql, values: params);
      return response;
    } catch (e) {
      Logs.logger.err(e.toString());
    }
  }

  static Future<void> addMod({required String serverName}) async {
    print("Username of the user you want to add as mod");
    String username = stdin.readLineSync().toString();
    String sql = '''
    INSERT INTO server_mods (server_name , mod_id )
    VALUES (@server_name , @mod_id) 
''';
    try {
      final modId =
          (await GetByParams.getUserByUsername(username: username))["id"];
      Map<String, dynamic> params = {
        "server_name": serverName,
        "mod_id": modId
      };
      final response = await BaseApi.db.query(sql: sql, values: params);
      print(response);
    } catch (e) {
      Logs.logger.err(e.toString());
    }
  }

  static Future<void> createChannel(
      {required int userId,
      required String serverName,
      required String channelName,
      required channelType channelType}) async {
    if (await ValidationApi.isModOfServer(
            serverName: serverName, modId: userId) ||
        await ValidationApi.isOwnerOfServer(
            serverName: serverName, userId: userId)) {
      String sql = '''
        INSERT INTO Channel (channel_name , channel_type ,  server_name)
        VALUES (@channel_name , @channel_type , @server_name)
    ''';
      //taking inputs
      final Map<String, dynamic> params = {
        "channel_name": channelName,
        "channel_type": channelType.toString(),
        "server_name": serverName
      };
      try {
        final response = await BaseApi.db.query(sql: sql, values: params);
        print(response);
      } catch (e) {
        Logs.logger.err(e.toString());
      }
    } else {
      print("Nah fam who you try to fool");
      print("You're not him brother get the hell out of here");
      exit(11);
    }
  }

  static Future<void> createChannelMessage(
      {required String messageText,
      required int channelId,
      required int userId}) async {
    String sql = '''
  INSERT INTO message_channel (channel_id , sender , message)
  VALUES (@channel_id , @sender , @message)
''';
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
    String sql = '''
  INSERT INTO message_dm (to_send , sender , message)
  VALUES (@to_send , @sender , @message)
''';
    final Map<String, dynamic> params = {
      "to_send": user["id"],
      "sender": sender,
      "message": messageText
    };
    try {
      await BaseApi.db.query(sql: sql, values: params);
      print("Message sent");
    } catch (e) {
      Logs.logger.err(e.toString());
    }
  }
}
