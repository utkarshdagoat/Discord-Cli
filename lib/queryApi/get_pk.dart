import 'dart:io';
import 'package:discordcli/queryApi/BaseApi.dart';
import 'package:discordcli/models/User.dart';

class GetByParams extends BaseApi {
  static Future<void> getUserByUsername({required String username}) async {
    final db = await BaseApi.init();
    String sql = '''
      SELECT * FROM users WHERE username=@username
    ''';
    Map<String, dynamic> params = {"username": username};
    try {
      final response = await db.query(sql: sql, values: params);
      print(response);
    } catch (e) {
      print(e);
      print("Validation Error");
      exit(3);
    }
  }
}
