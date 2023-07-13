import 'dart:async';
import 'package:discordcli/db.dart';

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
