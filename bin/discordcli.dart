import 'package:discordcli/api/usersApi.dart';
import 'dart:io';

Future<void> main(List<String> arguments) async {
  while (true) {
    print("Enter command you want to use , type exit if you want to exit");
    final command = stdin.readLineSync().toString().toLowerCase();
    switch (command) {
      case "register":
        await UserApi.register();
        break;
      case "login":
        await UserApi.login();
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
