import 'dart:async';
import 'package:discordcli/db/db.dart';

abstract class BaseApi {
  static late DB db;

  static Future<void> init() async {
    db = await DB.connect();
  }

  static Future<bool> close() async {
    return db.close();
  }
}
