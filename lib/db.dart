import 'package:postgres/postgres.dart';
import 'package:dotenv/dotenv.dart' as dotenv;
import 'dart:io';

final env = dotenv.DotEnv(includePlatformEnvironment: true)
  ..load(['/home/utkarsh/Discord-Cli/discordcli/.env']);

class DB {
  late PostgreSQLConnection _conn;

  static Future<DB> connect() async {
    final databaseUri = env["DATABASE_URI"].toString();
    final uriComponents = Uri.parse(databaseUri);

    final _host = uriComponents.host;
    final _port = 5432;
    final _database = uriComponents.path.substring(1);
    final _username = uriComponents.userInfo.split(':')[0];
    final _password = uriComponents.userInfo.split(':')[1];
    //print("${_host} ${_password} ${_port} ${_username} ${_database}");

    DB db = DB();

    db._conn = PostgreSQLConnection(_host, _port, _database,
        username: _username, password: _password);
    await db._conn.open();

    await db._conn.query('''
    CREATE TABLE IF NOT EXISTS users(
      id serial primary key not null,
      username text,
      password text
    )
''');

    print("Connected to server");
    return db;
  }

  Future<List<dynamic>> query(
      {required String sql, required Map<String, dynamic> values}) async {
    try {
      return await _conn.query(sql, substitutionValues: values);
    } catch (e) {
      return Future.value([]);
    }
  }
}
