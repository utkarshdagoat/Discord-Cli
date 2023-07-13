import 'package:discordcli/queryApi/BaseApi.dart';

class GetAll extends BaseApi {
  static Future<List<dynamic>> allUsers() async {
    List<Map<String, dynamic>> FetchedQuery = [];
    BaseApi.init();
    String sql = "SELECT * FROM users";
    dynamic result = await BaseApi.db.query(sql: sql, values: {});
    for (final row in result) {
      FetchedQuery.add({"id": row[0], "username": row[1], "password": row[2]});
    }
    return FetchedQuery;
  }
}
