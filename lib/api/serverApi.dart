import 'package:discordcli/api/usersApi.dart';
import 'package:discordcli/models/server.dart';
import 'package:discordcli/queryApi/create.dart';
import 'package:discordcli/queryApi/get_all.dart';
import 'dart:io';
import 'package:discordcli/queryApi/validation.dart';
import 'package:discordcli/logger/log.dart';

class ServerApi {
  static late Server server;

  static Future<void> createServer() async {
    //take input
    print("Enter the server name");
    final serverName = stdin.readLineSync().toString();
    try {
      await Create.createServer(userId: UserApi.userId, serverName: serverName);
    } catch (e) {
      Logs.logger.err('\n $e.toString()');
      exit(10);
    }
  }

  static Future<void> joinServer() async {
    print('Enter server name');
    String serverName = stdin.readLineSync().toString();
    if (!await ValidationApi.isServerValid(serverName: serverName)) {
      Logs.logger.err('\n $serverName Does Not exist');
      return;
    }
    try {
      if (!await ValidationApi.isInServer(
          serverName: serverName, userId: UserApi.userId)) {
        await Create.joinServer(userId: UserApi.userId, serverName: serverName);
        Logs.logger.success('$serverName joined  \n');
      } else {
        Logs.logger.warn('You are already in $serverName server foo.');
      }
    } catch (e) {
      Logs.logger.err(e.toString());
    }
  }

  static Future<void> makeMod() async {
    print("Server Name:");
    String serverName = stdin.readLineSync().toString();
    print("username of the user you want to add as mod:");
    String userName = stdin.readLineSync().toString();
    try {
      if (server.relationWithUser == 'owner') {
        await Create.addMod(serverName: serverName, username: userName);
        return;
      } else {
        print("bruh!!! You are not the owner");
        return;
      }
    } catch (e) {
      Logs.logger.err(e.toString());
    }
  }

  static Future<Map<String, dynamic>> showingServers() async {
    await Logs.waiting(message: 'Loading your servers');
    print('\n');
    List<String> serverChoices = [];
    bool serverJoined = false;
    try {
      final servers = await GetAll.getAllServersOfUser(userId: UserApi.userId);
      for (final server in servers) {
        serverChoices.add(server.serverName);
      }
      serverChoices.add('<-');
      final serverChoice = Logs.logger.chooseOne(
          'Which one of the following actions would you like to do',
          choices: serverChoices);
      if (serverChoice == '<-') {
        return {"serverJoined": false};
      }
      servers.forEach((element) {
        if (element.serverName == serverChoice) {
          server = element;
          serverJoined = true;
        }
      });
      return {"serverJoined": serverJoined};
    } catch (e) {
      Logs.logger.err(e.toString());
      print('\n');
      exit(11);
    }
  }
}
