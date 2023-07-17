import 'dart:io';

import 'package:discordcli/models/message.dart';
import 'package:discordcli/queryApi/BaseApi.dart';
import 'package:discordcli/queryApi/get_params.dart';

class GetAll {
  static Future<List<dynamic>> allUsers() async {
    List<Map<String, dynamic>> FetchedQuery = [];
    String sql = "SELECT * FROM users";
    dynamic result = await BaseApi.db.query(sql: sql, values: {});
    for (final row in result) {
      FetchedQuery.add({"id": row[0], "username": row[1], "password": row[2]});
    }
    return FetchedQuery;
  }

  static Future<List<Message>> messages({required int channelId}) async {
    List<Message> fetchedMessages = [];
    String sql =
        '''SELECT * FROM message_channel WHERE channel_id=@channel_id ORDER BY time_sent DESC LIMIT 10''';
    Map<String, dynamic> params = {"channel_id": channelId};
    try {
      final result = await BaseApi.db.query(sql: sql, values: params);
      if (result.isEmpty) {
        print("No messages to show");
        return fetchedMessages;
      }
      for (final row in result) {
        fetchedMessages.add(await Message.fromResponse(row: row));
      }
      return fetchedMessages;
    } catch (e) {
      print(e);
      exit(10);
    }
  }

  static Future<List<Message>> dmMessage({required int userId}) async {
    List<Message> fetchedMessages = [];
    String sql =
        '''SELECT * FROM message_dm WHERE to_send=@user_id ORDER BY time_sent DESC LIMIT 10''';

    Map<String, dynamic> params = {"user_id": userId};
    try {
      final result = await BaseApi.db.query(sql: sql, values: params);
      if (result.isEmpty) {
        print("No messages to show");
        return fetchedMessages;
      }
      for (final row in result) {
        fetchedMessages.add(await Message.fromResponse(row: row));
      }
      return fetchedMessages;
    } catch (e) {
      print(e);
      exit(10);
    }
  }
}
