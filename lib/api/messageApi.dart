import 'dart:io';
import 'package:discordcli/api/usersApi.dart';
import 'package:discordcli/queryApi/create.dart';
import 'package:discordcli/helper/late.dart';
import 'package:discordcli/models/message.dart';
import 'package:discordcli/queryApi/get_all.dart';
import 'package:discordcli/logger/log.dart';

class MessageApi {
  static Future<void> sendMessage() async {
    print("Whom you want to send messages to");
    final toSend = stdin.readLineSync().toString();
    print("Enter Message:");
    final messageText = stdin.readLineSync().toString();
    try {
      if (messageText.isEmpty) {
        print("Enter A valid message");
        return;
      }
      await Create.createDmMessage(
          messageText: messageText,
          sender: UserApi.userId,
          toSendUsername: toSend);
    } catch (e) {
      if (isLateInitializationError(e)) {
        print("Enter the channel first");
        return;
      }
      Logs.logger.err(e.toString());
      exit(11);
    }
  }

  static Future<void> fetchDmMessage() async {
    try {
      final res = await GetAll.dmMessage(userId: UserApi.userId);
      for (final message in res) {
        Message.format(
            username: message.senderName,
            timeStamp: message.timeStamp,
            message: message.message);
      }
      return;
    } catch (e) {
      Logs.logger.err(e.toString());
      return;
    }
  }
}
