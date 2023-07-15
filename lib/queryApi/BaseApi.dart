import 'dart:async';
import 'package:discordcli/db/cacheDb.dart';
import 'package:discordcli/db/db.dart';

abstract class BaseApi {
  static late DB db;

  static Future<DB> init() async {
    db = await DB.connect();
    return db;
  }

  static Future<bool> close() async {
    return db.close();
  }
}
