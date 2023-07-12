import 'package:discordcli/models/User.dart';
import 'package:discordcli/queryApi/BaseApi.dart';

class Create extends BaseApi {
  static Future<User> createUser(dynamic data) async {
    final db = await BaseApi.init();

    User user = User.fromMap(data);
    String sql = '''
        INSERT INTO users (username , password ) 
        VALUES ('${user.username}', '${user.hashPwd(pass: user.password)}') returning id
        ''';
    Map<String, dynamic> params = {
      "username": user.username,
      "password": user.password,
    };

    dynamic result = await db.query(sql: sql, values: params);

    return user;
  }
}
