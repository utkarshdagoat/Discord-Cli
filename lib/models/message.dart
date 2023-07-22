import 'package:chalkdart/chalk.dart';
import 'package:discordcli/models/User.dart';
import 'package:discordcli/queryApi/get_params.dart';

class Message {
  late String message;
  late String senderName;
  late DateTime timeStamp;

  Message(
      {required String message,
      required String userName,
      required DateTime timeStamp}) {
    this.message = message;
    senderName = userName;
    this.timeStamp = timeStamp;
  }

  static Future<Message> fromResponse({required dynamic row}) async {
    final userName = await GetByParams.getUsernameByUserId(userId: row[2]);
    return Message(message: row[3], userName: userName, timeStamp: row[4]);
  }

  static void format(
      {required String username,
      required DateTime timeStamp,
      required String message}) {
    final time = timeStamp.toString().split('.')[0];
    final messageTxt = chalk.green(
        '$time ${chalk.blue.underline.bold(username)}${chalk.blue(' $message ')}');
    print(messageTxt);
    return;
  }

  static Message fromList(List<dynamic> list) =>
      Message(message: list[3], userName: list[2], timeStamp: list[4]);
}

class DmMessage {
  late String message;
  late User sender;
  late User toSend;
}

//fetch server name channel name
//fetch dm
//send server name channel name
//send dm
