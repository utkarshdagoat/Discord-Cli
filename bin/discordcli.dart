import 'dart:io';
import 'package:discordcli/logger/log.dart';
import 'package:discordcli/models/category.dart';
import 'package:discordcli/models/server.dart';
import 'package:discordcli/models/User.dart';
import 'package:discordcli/models/message.dart';
import 'package:discordcli/models/channels.dart';
import 'package:discordcli/queryApi/BaseApi.dart';

Future<void> main(List<String> arguments) async {
  await Logs.intialProg(message: 'Trying to logging you in');
  print('\n');
  await BaseApi.init();
  await User.persistLogin();
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
        await User.logout();
        break;
      case "exit":
        await Logs.waiting(message: 'Exiting...');
        Logs.logger.success("\nThank you for using discord cli");
        print('\n');
        exit(0);
      case "create server":
        await Logs.waiting(message: 'Creating Server...');
        print('\n');
        await Server.createServer();
        break;
      case "join server":
        await Logs.waiting(message: 'Joining server...');
        print('\n');
        await Server.joinServer();
        break;
      case "checkout your servers":
        final res = await Server.showingServers();
        if (res["serverJoined"]) {
          while (await Category.showCategories()) {
            while (await Channel.showAllChannelInCategories()) {
              final command = Logs.logger.chooseOne(
                  'What would you like to do today?',
                  choices: ['send messages', 'fetch messages', 'exit']);
              switch (command) {
                case 'send messages':
                  await Channel.sendMessage();
                  break;
                case 'fetch messages':
                  await Channel.fetchMessage();
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
        await Message.sendMessage();
        break;
      case "fetch dm":
        await Logs.waiting(message: 'fetching....');
        print('\n');
        await Message.fetchDmMessage();
        break;
      default:
        print("Not a valid command see docs!!");
        break;
    }
  }
}
