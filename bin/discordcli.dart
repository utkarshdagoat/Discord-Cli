import 'package:discordcli/api/serverApi.dart';
import 'package:discordcli/api/usersApi.dart';
import 'dart:io';
import 'package:discordcli/db/cacheDb.dart';
import 'package:discordcli/queryApi/create.dart';
import 'package:discordcli/queryApi/get_params.dart';

Future<void> main(List<String> arguments) async {
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
        String name = stdin.readLineSync().toString();
        await ServerApi.joinServer(serverName: name);
      case "make mod":
        await ServerApi.makeMod();
      default:
        print("Not a valid command see docs!!");
        break;
    }
  }
}
