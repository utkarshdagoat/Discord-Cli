import 'package:discordcli/api/usersApi.dart';
import 'dart:io';
import 'package:discordcli/db/cacheDb.dart';

Future<void> main(List<String> arguments) async {
  await UserApi.persistLogin();
  while (true) {
    print("Enter command you want to use , type exit if you want to exit");
    final command = stdin.readLineSync().toString().toLowerCase();
    switch (command) {
      case "logout":
        await UserApi.logout();
      case "exit":
        print("Thank you for using discord cli");
        exit(0);
      default:
        print("Not a valid command see docs!!");
    }
  }
}
