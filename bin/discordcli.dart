import 'dart:html';

import 'package:discordcli/api/channelApi.dart';
import 'package:discordcli/api/messageApi.dart';
import 'package:discordcli/api/serverApi.dart';
import 'package:discordcli/api/usersApi.dart';
import 'package:discordcli/queryApi/BaseApi.dart';
import 'dart:io';
import 'package:discordcli/queryApi/validation.dart';
import 'package:redis/redis.dart';

Future<void> main(List<String> arguments) async {
  await BaseApi.init();
  await UserApi.persistLogin();
  while (true) {
    print("Enter command you want to use , type exit if you want to exit");
    final command = stdin.readLineSync().toString().toLowerCase();
    switch (command) {
      case "logout":
        await UserApi.logout();
        break;
      case "exit":
        print("Thank you for using discord cli");
        exit(0);
      case "create server":
        await ServerApi.createServer();
        break;
      case "join server":
        print("Server Name");
        String name = stdin.readLineSync().toString();
        await ServerApi.joinServer(serverName: name);
        break;
      case "make mod":
        await ServerApi.makeMod();
        break;
      case "create channel":
        await ChannelApi.createChannel();
        break;
      case "join channel":
        await ChannelApi.enterChannel();
        bool joinedChannel = true;
        while (joinedChannel) {
          print('What would you like to do send or fetch messages');
          String response = stdin.readLineSync().toString();
          switch (response) {
            case "send":
              await ChannelApi.sendMessage();
              break;
            case "fetch":
              await ChannelApi.fetchMessage();
              break;
            case "exit channel":
              print('Exiting channel....');
              joinedChannel = false;
              break;
            default:
              print(
                  'Invalid command in a channel.Maybe you want to exit first see docs for more');
              break;
          }
        }
        break;
      case "send dm":
        await MessageApi.sendMessage();
        break;
      case "fetch dm":
        await MessageApi.fetchDmMessage();
        break;
      default:
        print("Not a valid command see docs!!");
        break;
    }
  }
}
