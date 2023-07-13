//This file contains the user endpoints like register user , logout user
//session creation logic
import 'dart:io';
import "package:discordcli/helper/inputs.dart";
import "package:discordcli/helper/late.dart";
import 'package:discordcli/models/User.dart';
import 'package:discordcli/models/Session.dart';
import 'package:discordcli/queryApi/create.dart';
import 'package:discordcli/queryApi/delete.dart';
import 'package:discordcli/queryApi/get_params.dart';

class UserApi with BaseInput {
  static late User user;
  static late Session session;

  static Future<User> register() async {
    Map<String, dynamic> inputs = BaseInput.get_inputs(User);
    user = await Create.createUser(inputs);
    return user;
  }
  //every other endpoint will take the session object as parameter , validate methon on session

  static Future<void> login() async {
    bool match = false;
    int loginTrys = 3;
    while (!match && loginTrys > 0) {
      Map<String, dynamic> inputs = BaseInput.get_inputs(User);
      try {
        user =
            await GetByParams.getUserByUsername(username: inputs["username"]);
        print(user.toString());
        match = user.comparePwd(passValue: inputs["password"]);
        if (match) {
          session = await Create.createSession(username: user.username);
          print("Logged in successfully");
        } else {
          print("Invalid credentials. You have ${loginTrys} left");
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
      final result = await GetByParams.isSeessionValid(
          useranme: user.username, session: session);
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
        await Delete.deleteSession(session);
        print("logged out");
      } catch (e) {
        print(e);
      }
    }
  }
}
