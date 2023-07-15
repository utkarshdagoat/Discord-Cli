import 'dart:io';

import 'package:discordcli/models/Session.dart';
import 'package:discordcli/models/User.dart';
import 'package:discordcli/models/server.dart';
import 'package:discordcli/queryApi/BaseApi.dart';
import 'package:discordcli/queryApi/get_params.dart';

class Create extends BaseApi {
  static Future<User> createUser(dynamic data) async {
    final db = await BaseApi.init();

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
      final response = await db.query(sql: sql, values: params);
    } catch (e) {
      print(e);
    }

    return user;
  }

  static Future<Session> createSession({required int user_id}) async {
    final db = await BaseApi.init();

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
      await db.query(sql: sql, values: params);
    } catch (e) {
      print('Invalid Session logic');
      print(e);
      exit(2);
    }

    return session;
  }

  static Future<Server> createServer(
      {required int userId, required String serverName}) async {
    final db = await BaseApi.init();
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
      final response = await db.query(sql: sql, values: params);
      print(response);
    } catch (e) {
      print(e);
    }

    return server;
  }

  static Future<dynamic> joinServer(
      {required int userId, required int serverId}) async {
    final db = await BaseApi.init();
    String sql = '''
    INSERT INTO server_users (server_id , user_id )
    VALUES (@server_id , @user_id)
''';
    Map<String, dynamic> params = {
      "server_id": serverId,
      "user_id": userId,
    };
    try {
      final response = await db.query(sql: sql, values: params);
      return response;
    } catch (e) {
      print(e);
      exit(10);
    }
  }

  static Future<void> addMod({required String serverName}) async {
    print("Username of the user you want to add as mod");
    String username = stdin.readLineSync().toString();
    final db = await BaseApi.init();
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
      final response = await db.query(sql: sql, values: params);
      print(response);
    } catch (e) {
      print(e);
      exit(10);
    }
  }
}
