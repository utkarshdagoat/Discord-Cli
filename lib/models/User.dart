import 'package:crypt/crypt.dart';
import 'dart:io';
import 'package:discordcli/db/cacheDb.dart';
import "package:discordcli/helper/inputs.dart";
import "package:discordcli/helper/late.dart";
import 'package:discordcli/models/Session.dart';
import 'package:discordcli/queryApi/create.dart';
import 'package:discordcli/queryApi/delete.dart';
import 'package:discordcli/queryApi/get_params.dart';
import 'package:discordcli/queryApi/validation.dart';
import 'package:discordcli/logger/log.dart';

class User {
  static String username = '';
  static String password = '';
  static CacheDb cache = CacheDb();
  static late Session session;
  static late int userId;

  User({
    required String usrname,
    required String pass,
  }) {
    username = usrname;
    password = pass;
  }

  get getUsername => username;
  get getPass => password;
  get getUserId => userId;

  static SetUserInputs(
      {required int Id, required String UserName, required String pass}) {
    username = UserName;
    password = pass;
    userId = Id;
  }

  static String hashPwd({required String pass}) {
    return Crypt.sha256(pass, rounds: 1000).toString();
  }

  static bool comparePwd({required String passValue}) {
    final hashPwd = Crypt(password);
    return hashPwd.match(passValue);
  }

  static User fromMap(Map<String, dynamic> map) => User(
        usrname: map["username"].toString(),
        pass: map["password"].toString(),
      );
  Map<String, String> toMap(List values) =>
      {"id": values[0], "username": values[1], "password": values[2]};

  User.fromList(List<dynamic> list) {
    username = list[0][1];
    password = list[0][2];
  }

  static Future<void> register() async {
    Map<String, dynamic> inputs = BaseInput.get_inputs(User);
    Logs.logger.success('\nYou are Registered SuccessFully');
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
          Logs.logger.info("Please login again Session has ended");
          await login();
        } else {
          User(
              pass: response["user"].password,
              usrname: response["user"].username);
          userId = response["id"];
          Logs.logger.detail(
              "\n Welcome back ${username}. What would you like to do today?");
        }
      } catch (e) {
        Logs.logger.err;
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
      Logs.logger.warn(
          '\nIf you are seeing this for the first time enter any gibberish');
      Map<String, dynamic> inputs = BaseInput.get_inputs(User);
      try {
        final res =
            (await GetByParams.getUserByUsername(username: inputs["username"]));
        User.SetUserInputs(
            Id: res["id"],
            UserName: res["user"].getUsername,
            pass: res["user"].getPass);

        cache.store(username: res["user"].username);
        match = comparePwd(passValue: inputs["password"]);

        if (match) {
          session = await Create.createSession(user_id: await res["id"]);
          userId = res["id"];
          Logs.logger.success("\nLogged in successfully");
        } else {
          Logs.logger
              .warn('\n' "Invalid credentials. You have $loginTrys left");
        }
      } catch (e) {
        Logs.logger.err(e.toString());
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
        Logs.logger.success("\nlogged out.Thank you for using discord-cli");
        exit(0);
      } catch (e) {
        Logs.logger.err(e.toString());
      }
    }
  }

  @override
  String toString() {
    print(username);
    return super.toString();
  }
}
