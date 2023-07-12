import 'dart:async';
import 'package:discordcli/db.dart';
import 'package:dotenv/dotenv.dart' as dotenv;
import 'dart:io';

abstract class BaseApi {
  static late DB db;

  static Future<DB> init() async {
    db = await DB.connect();
    return db;
  }
}
