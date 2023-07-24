import 'dart:io';
import 'package:discordcli/helper/late.dart';
import 'package:discordcli/models/message.dart';
import 'package:discordcli/queryApi/create.dart';
import 'package:discordcli/queryApi/get_all.dart';
import 'package:discordcli/logger/log.dart';
import 'package:discordcli/models/category.dart';
import 'package:discordcli/models/server.dart';
import 'package:discordcli/models/User.dart';

enum channelType { text, voice, announcement }

class Channel {
  static late int id;
  static late String channelName;
  static late channelType channeltype;

  get getChannelId => id;
  get getChannelName => channelName;
  get getChannelType => channeltype;

  Channel(int id, String cN, String cT) {
    Channel.id = id;
    Channel.channelName = cN;
    Channel.channeltype =
        channelType.values.firstWhere((element) => element.toString() == cT);
  }

  static Channel fromList(List<dynamic> list) =>
      Channel(list[0], list[1], list[2]);

  static Future<void> createChannel() async {
    print("Enter Channel Name");
    final channelName = stdin.readLineSync().toString();
    print("Enter channel type");
    final inputChannelType = stdin.readLineSync().toString();
    try {
      channelType channelT = channelType.values.byName(inputChannelType);
      await Create.createChannel(
          userId: User.userId,
          categoryId: Category.categoryId,
          channelName: channelName,
          channelType: channelT);
    } catch (e) {
      if (e.toString().contains('Invalid argument (name)')) {
        print("Invalid channel Type");
        exit(11);
      }
      Logs.logger.err(e.toString());
    }
  }

  static Future<void> sendMessage() async {
    if (channeltype.toString() == 'channelType.announcement') {
      if (!(Server.relationWithUser == 'mod' ||
          Server.relationWithUser == 'owner')) {
        print("Sorry You are not allowed to send messages here");
        return;
      }
    }
    print("Enter Message:");
    final messageText = stdin.readLineSync().toString();
    try {
      if (messageText.isEmpty) {
        print("Enter A valid message");
        return;
      }
      await Create.createChannelMessage(
          messageText: messageText, channelId: id, userId: User.userId);
    } catch (e) {
      if (isLateInitializationError(e)) {
        print("Enter the channel first");
        return;
      }
      Logs.logger.err(e.toString());
      exit(11);
    }
  }

  static Future<void> fetchMessage() async {
    try {
      final res = await GetAll.messages(channelId: id);
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

  static Future<bool> showAllChannelInCategories() async {
    List<String> allChannels = [];
    try {
      final channels =
          await GetAll.getAllChannelsCategory(categoryId: Category.categoryId);
      for (var i = 0; i < channels.length; i++) {
        allChannels.add(channels[i].getChannelName);
      }
      if (Server.relationWithUser == 'mod' ||
          Server.relationWithUser == 'owner') {
        if (!Category.isPublic) {
          allChannels.add('Add user to this category');
        }
        allChannels.add('create channel');
      }
      allChannels.add('exit category');
      final channelChosen = Logs.logger
          .chooseOne('Channels of this category', choices: allChannels);
      if (channelChosen == 'create channel') {
        await createChannel();
        return false;
      } else if (channelChosen == 'Add user to this category') {
        await Category.addUserToPrivateCategory();
        return false;
      } else if (channelChosen == 'exit category') {
        return false;
      } else {
        for (var i = 0; i < channels.length; i++) {
          if (channels[i].getChannelName == channelChosen) {
            Channel(channels[i].getChannelId, channels[i].getChannelName,
                channels[i].getChannelType);
            return true;
          }
        }
        print('No such channel');
        return false;
      }
    } catch (e) {
      print(e);
      exit(11);
    }
  }
}
