import 'dart:io';

import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:discordcli/logger/log.dart';

class CacheDb {
  String dbPath = 'user.db';
  DatabaseFactory dbFactory = databaseFactoryIo;
  late Database _db;
  final _store = StoreRef.main();

  Future<void> connect() async {
    _db = await dbFactory.openDatabase(dbPath);
  }

  Future<void> store({required String username}) async {
    await _store.record('username').put(_db, username);
  }

  Future<String?> get() async {
    final username = await _store.record('username').get(_db) as String?;
    return username;
  }

  Future<void> delete() async {
    try {
      await _store.record('username').delete(_db);
    } catch (e) {
      Logs.logger.err(e.toString());
      exit(10);
    }
  }
}
