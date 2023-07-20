import 'package:discordcli/api/categoryApi.dart';
import 'package:discordcli/api/channelApi.dart';
import 'package:discordcli/api/messageApi.dart';
import 'package:discordcli/api/serverApi.dart';
import 'package:discordcli/api/usersApi.dart';
import 'package:discordcli/queryApi/BaseApi.dart';
import 'dart:io';
import 'package:discordcli/logger/log.dart';

Future<void> main(List<String> arguments) async {
  await Logs.intialProg(message: 'Trying to logging you in');
  print('\n');
  await BaseApi.init();
  await UserApi.persistLogin();
  print('\n');
  while (true) {
    final command =
        Logs.logger.chooseOne('What would you like to do today?', choices: [
      'create server',
      'join server',
      'checkout your servers',
      'send dm',
      'fetch dm',
      'logout',
      'exit'
    ]);
    switch (command) {
      case "logout":
        await Logs.waiting(message: 'Trying to logging you out');
        print('\n');
        await UserApi.logout();
        break;
      case "exit":
        await Logs.waiting(message: 'Exiting...');
        Logs.logger.success("\nThank you for using discord cli");
        print('\n');
        exit(0);
      case "create server":
        await Logs.waiting(message: 'Creating Server...');
        print('\n');
        await ServerApi.createServer();
        break;
      case "join server":
        await Logs.waiting(message: 'Joining server...');
        print('\n');
        await ServerApi.joinServer();
        break;
      case "checkout your servers":
        final res = await ServerApi.showingServers();
        if (res["serverJoined"]) {
          while (await CategoryApi.showCategories()) {
            while (await ChannelApi.showAllChannelInCategories()) {
              final command = Logs.logger.chooseOne(
                  'What would you like to do today?',
                  choices: ['send messages', 'fetch messages', 'exit']);
              switch (command) {
                case 'send messages':
                  await ChannelApi.sendMessage();
                  break;
                case 'fetch messages':
                  await ChannelApi.fetchMessage();
                  break;
                case 'exit':
                  print('Thank you for using discord-cli');
                  exit(11);
              }
            }
          }
        }
      case "send dm":
        await Logs.waiting(message: 'Sending....');
        print('\n');
        await MessageApi.sendMessage();
        break;
      case "fetch dm":
        await Logs.waiting(message: 'fetching....');
        print('\n');
        await MessageApi.fetchDmMessage();
        break;
      default:
        print("Not a valid command see docs!!");
        break;
    }
  }
}
