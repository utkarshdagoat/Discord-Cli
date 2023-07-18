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
      'make mod',
      'join channel',
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
        print("Server Name");
        String name = stdin.readLineSync().toString();
        await Logs.waiting(message: 'Joining server...');
        print('\n');
        await ServerApi.joinServer(serverName: name);
        break;
      case "make mod":
        await ServerApi.makeMod();
        await Logs.waiting(message: 'Making mod..');
        print('\n');
        break;
      case "create channel":
        await Logs.waiting(message: 'Creating channel..');
        print('\n');
        await ChannelApi.createChannel();
        break;
      case "join channel":
        await Logs.waiting(message: 'Joining channel..');
        print('\n');
        await ChannelApi.enterChannel();
        bool joinedChannel = true;

        while (joinedChannel) {
          final response = Logs.logger.chooseOne(
              'What would you like to do today?',
              choices: ['send', 'fetch', 'exit channel']);
          switch (response) {
            case "send":
              await Logs.waiting(message: 'sending..');
              print('\n');
              await ChannelApi.sendMessage();
              break;
            case "fetch":
              Logs.waiting(message: 'fetching..');
              print('\n');
              await ChannelApi.fetchMessage();
              break;
            case "exit channel":
              Logs.logger.warn('Exiting channel....');
              print('\n');
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
