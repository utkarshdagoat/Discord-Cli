//This file contains the user endpoints like register user , logout user
//session creation logic
import 'dart:io';
import 'package:discordcli/db/cacheDb.dart';
import "package:discordcli/helper/inputs.dart";
import "package:discordcli/helper/late.dart";
import 'package:discordcli/models/User.dart';
import 'package:discordcli/models/Session.dart';
import 'package:discordcli/queryApi/create.dart';
import 'package:discordcli/queryApi/delete.dart';
import 'package:discordcli/queryApi/get_params.dart';
import 'package:discordcli/queryApi/validation.dart';

class UserApi with BaseInput {
  static late User user;
  //remove late take cache session as inital value
  static late Session session;
  static late int userId;

  static CacheDb cache = CacheDb();

  static Future<User> register() async {
    Map<String, dynamic> inputs = BaseInput.get_inputs(User);
    user = await Create.createUser(inputs);
    return user;
  }

  static Future<void> persistLogin() async {
    await cache.connect();
    final username = await cache.get();
    if (username == null) {
      await login();
      return;
    } else {
      try {
        final response =
            await GetByParams.getUserByUsername(username: username);

        final match =
            await ValidationApi.isSeessionValid(userId: response["id"]);
        if (!match) {
          print("Please login again Session has ended");
          await login();
        } else {
          user = response["user"];
          userId = response["id"];
          print(
              "Welcome back ${user.username}. What would you like to do today?");
        }
      } catch (e) {
        print(e);

        exit(10);
      }
    }
  }

  //every other endpoint will take the session object as parameter , validate methon on session
  //cache session locally to not fetch it again and again
  //if sessoion in cache is valid then you're already logged in if not log in first
  static Future<void> login() async {
    await cache.connect();
    bool match = false;
    int loginTrys = 3;
    while (!match && loginTrys > 0) {
      Map<String, dynamic> inputs = BaseInput.get_inputs(User);
      try {
        final res =
            (await GetByParams.getUserByUsername(username: inputs["username"]));
        user = await res["user"];
        cache.store(username: user.username);
        match = user.comparePwd(passValue: inputs["password"]);

        if (match) {
          session = await Create.createSession(user_id: await res["id"]);
          userId = res["id"];
          print("Logged in successfully");
        } else {
          print("Invalid credentials. You have $loginTrys left");
        }
      } catch (e) {
        print(e);
        print("Some Error Occured");
        exit(6);
      }
      loginTrys--;
    }
  }

  static Future<bool> isAuthenticated() async {
    try {
      final result = await ValidationApi.isSeessionValid(userId: userId);
      if (!result) {
        print("login first");
        return false;
      }
    } catch (e) {
      if (isLateInitializationError(e)) {
        print("login first");
        return false;
      }
    }
    return true;
  }

  static Future<void> logout() async {
    if (await isAuthenticated()) {
      try {
        await cache.delete();
        await Delete.deleteSession(userId);
        print("logged out.Thank you for using discord-cli");
        exit(0);
      } catch (e) {
        print(e);
      }
    }
  }
}
