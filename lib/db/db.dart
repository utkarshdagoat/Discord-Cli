import 'dart:io';
import 'package:discordcli/helper/duplicate.dart';
import 'package:discordcli/helper/server.dart';
import 'package:postgres/postgres.dart';
import 'package:dotenv/dotenv.dart' as dotenv;
import 'package:discordcli/helper/unique.dart';
import 'package:discordcli/logger/log.dart';
import 'package:discordcli/sql/tables.dart';

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
      for (final query in SqlTables.queries) {
        await db._conn.query(query);
      }
    } on SocketException {
      print("Please connect to the internet");
      exit(5);
    } catch (e) {
      Logs.logger.err(e.toString());
      print("Unable to connect to DB");
      exit(1);
    }
    return db;
  }

  Future<List<dynamic>> query(
      {required String sql, required Map<String, dynamic> values}) async {
    try {
      return await _conn.query(sql, substitutionValues: values);
    } on SocketException {
      print("Please connect to the internet");
    } catch (e) {
      Logs.logger.err(e.toString());
      print('\n');
      if (isServerNameTaken(e)) {
        print("Sever Name already exits");
        exit(11);
      }
      if (isLoggedInSomewher(e)) {
        print(
            "You are trying to overwrite a database entry which already exists.You are already in the databse");
        exit(10);
      }
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
