import 'dart:io';

import 'package:discordcli/models/category.dart';
import 'package:discordcli/models/channels.dart';
import 'package:discordcli/models/message.dart';
import 'package:discordcli/models/server.dart';
import 'package:discordcli/queryApi/BaseApi.dart';
import 'package:discordcli/logger/log.dart';
import 'package:discordcli/sql/get_all.dart';

class GetAll {
  static Future<List<Message>> messages({required int channelId}) async {
    List<Message> fetchedMessages = [];
    Map<String, dynamic> params = {"channel_id": channelId};
    try {
      final result = await BaseApi.db
          .query(sql: SqlGetAll.getChannelMessages, values: params);
      if (result.isEmpty) {
        print("No messages to show");
        return fetchedMessages;
      }
      for (final row in result) {
        fetchedMessages.add(await Message.fromResponse(row: row));
      }
      return fetchedMessages;
    } catch (e) {
      Logs.logger.err(e.toString());
      exit(10);
    }
  }

  static Future<List<Message>> dmMessage({required int userId}) async {
    List<Message> fetchedMessages = [];
    Map<String, dynamic> params = {"user_id": userId};
    try {
      final result =
          await BaseApi.db.query(sql: SqlGetAll.getDmMessages, values: params);
      if (result.isEmpty) {
        print("No messages to show");
        return fetchedMessages;
      }
      for (final row in result) {
        fetchedMessages.add(await Message.fromResponse(row: row));
      }
      return fetchedMessages;
    } catch (e) {
      Logs.logger.err(e.toString());
      exit(10);
    }
  }

  //list pf channels
  static Future<List<Server>> getAllServersOfUser({required int userId}) async {
    List<Server> fetchedServer = [];
    Map<String, dynamic> params = {"user_id": userId};
    try {
      final ownerResponse = await BaseApi.db
          .query(sql: SqlGetAll.getServerWhereOwner, values: params);
      if (ownerResponse.isNotEmpty) {
        for (final row in ownerResponse) {
          fetchedServer.add(Server.fromSeverOwnerTable(response: row));
        }
      }
      final modResponse = await BaseApi.db
          .query(sql: SqlGetAll.getServerWhereMod, values: params);
      if (modResponse.isNotEmpty) {
        for (final row in modResponse) {
          fetchedServer.add(Server.fromSeverModTable(response: row));
        }
      }
      final userResponse = await BaseApi.db
          .query(sql: SqlGetAll.getServerWhereUser, values: params);
      if (userResponse.isNotEmpty) {
        for (final row in userResponse) {
          fetchedServer.add(Server.fromSeverUserTable(response: row));
        }
      }
      return fetchedServer;
    } catch (e) {
      Logs.logger.err('\n ${e.toString()}');
      exit(11);
    }
  }

  static Future<List<Category>> getAllCategoriesOfServer(
      {required int serverId}) async {
    List<Category> fetchedCategory = [];
    Map<String, dynamic> params = {"server_id": serverId};
    try {
      final res = await BaseApi.db
          .query(sql: SqlGetAll.getCategoryOfServer, values: params);
      for (final row in res) {
        fetchedCategory.add(Category.fromResponse(response: row));
      }
      return fetchedCategory;
    } catch (e) {
      print(e);
      exit(10);
    }
  }

  static Future<List<Channel>> getAllChannelsCategory(
      {required int categoryId}) async {
    List<Channel> fetchedChannels = [];

    Map<String, dynamic> params = {"category_id": categoryId};
    try {
      final res = await BaseApi.db
          .query(sql: SqlGetAll.getChannelsofCategories, values: params);
      for (final row in res) {
        fetchedChannels.add(Channel.fromList(row));
      }
      return fetchedChannels;
    } catch (e) {
      print(e);
      exit(10);
    }
  }
}
