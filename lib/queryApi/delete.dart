import 'dart:io';
import 'package:discordcli/logger/log.dart';
import 'package:discordcli/sql/delete.dart';

import 'BaseApi.dart';

class Delete extends BaseApi {
  static Future<void> deleteSession(int userId) async {
    Map<String, dynamic> params = {"user_id": userId};
    try {
      await BaseApi.db.query(sql: DeleteSql.deleteSession, values: params);
    } catch (e) {
      Logs.logger.err(e.toString());
      exit(10);
    }
  }
}
