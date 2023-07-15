import 'dart:io';

import 'package:discordcli/models/Session.dart';
import 'package:discordcli/models/User.dart';
import 'package:discordcli/queryApi/BaseApi.dart';

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
}
