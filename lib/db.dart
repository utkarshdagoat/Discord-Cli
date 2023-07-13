import 'dart:io';

import 'package:postgres/postgres.dart';
import 'package:dotenv/dotenv.dart' as dotenv;

final env = dotenv.DotEnv(includePlatformEnvironment: true)
  ..load(['/home/utkarsh/Discord-Cli/discordcli/.env']);

class DB {
  late PostgreSQLConnection _conn;

  static Future<DB> connect() async {
    final databaseUri = env["DATABASE_URI"].toString();
    final uriComponents = Uri.parse(databaseUri);

    final host = uriComponents.host;
    final port = 5432;
    final database = uriComponents.path.substring(1);
    final username = uriComponents.userInfo.split(':')[0];
    final password = uriComponents.userInfo.split(':')[1];
    //print("${_host} ${_password} ${_port} ${_username} ${_database}");

    DB db = DB();

    db._conn = PostgreSQLConnection(host, port, database,
        username: username, password: password);

    try {
      await db._conn.open();

      //creating users table
      await db._conn.query('''
    CREATE TABLE IF NOT EXISTS users(
      id serial primary key not null,
      username text,
      password text
    )''');

      //creating session table
      await db._conn.query('''
    CREATE TABLE IF NOT EXISTS sessions(
      id serial primary key not null,
      sessionkey text not null,
      sessiondata text not null
    )
''');
    } on SocketException {
      print("Please connect to the internet");
      exit(5);
    } catch (e) {
      print("Unable to connect to DB");
      exit(1);
    }
    return db;
  }

  Future<List<dynamic>> query(
      {required String sql, required Map<String, dynamic> values}) async {
    try {
      print(sql);
      return await _conn.query(sql, substitutionValues: values);
    } on SocketException {
      print("Please connect to the internet");
    } catch (e) {
      print(e);
      print("Data Base Error Exiting...");
      exit(1);
    }
    return Future.value([]);
  }

  Future<bool> close() async {
    await _conn.close();
    return Future.value(true);
  }
}
