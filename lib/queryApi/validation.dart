import 'package:discordcli/sql/get_all.dart';

import 'BaseApi.dart';
import 'dart:io';
import 'package:discordcli/logger/log.dart';

class ValidationApi {
  static Future<bool> isSeessionValid({required int userId}) async {
    Map<String, dynamic> params = {"user_id": userId};
    try {
      final response = await BaseApi.db
          .query(sql: SqlGetAll.sessionsByUserId, values: params);
      if (response.isEmpty) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      Logs.logger.err(e.toString());
      exit(7);
    }
  }

  static Future<bool> isOwnerOfServer(
      {required String serverName, required int userId}) async {
    Map<String, dynamic> params = {"server_name": serverName};

    try {
      final owner = (await BaseApi.db
          .query(sql: SqlGetAll.ownerIdFromServer, values: params));
      if (owner.isEmpty) {
        return false;
      }
      if (owner[0][0] == userId) {
        return true;
      }
      return false;
    } catch (e) {
      Logs.logger.err(e.toString());
      exit(10);
    }
  }

  static Future<bool> isModOfServer(
      {required String serverName, required int modId}) async {
    Map<String, dynamic> params = {"server_name": serverName};
    try {
      final response = await BaseApi.db
          .query(sql: SqlGetAll.modIdFromServerMods, values: params);
      if (response.isEmpty) {
        return false;
      }
      var doesContain = false;
      for (var element in response) {
        if (element.contains(modId)) {
          doesContain = true;
        }
      }
      if (doesContain) return true;
      return false;
    } catch (e) {
      Logs.logger.err(e.toString());
      exit(10);
    }
  }

  static Future<bool> isInServer(
      {required String serverName, required int userId}) async {
    if (await isModOfServer(serverName: serverName, modId: userId) ||
        await isOwnerOfServer(serverName: serverName, userId: userId)) {
      return true;
    }

    Map<String, dynamic> params = {"server_name": serverName};
    try {
      final response = await BaseApi.db
          .query(sql: SqlGetAll.userIdFromServerUser, values: params);
      if (response.isEmpty) {
        return false;
      }
      var doesContain = false;
      for (var element in response) {
        if (element.contains(userId)) {
          doesContain = true;
        }
      }
      if (doesContain) return true;
      return false;
    } catch (e) {
      Logs.logger.err(e.toString());
      exit(10);
    }
  }

  static Future<bool> isServerValid({required String serverName}) async {
    Map<String, dynamic> params = {"server_name": serverName};
    try {
      final response = await BaseApi.db
          .query(sql: SqlGetAll.serverFromServerName, values: params);
      if (response.isEmpty) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      Logs.logger.err(e.toString());
      return false;
    }
  }

  static Future<bool> isAllowedToSeeCategory(
      {required int categoryId, required int userId}) async {
    Map<String, dynamic> params = {
      "user_id": userId,
      'category_id': categoryId
    };

    try {
      final response = await BaseApi.db
          .query(sql: SqlGetAll.validationForSeeingcategories, values: params);
      if (response.isEmpty) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      Logs.logger.err(e.toString());
      return false;
    }
  }
}
