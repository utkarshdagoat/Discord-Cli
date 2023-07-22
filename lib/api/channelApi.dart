import 'dart:io';
import 'package:discordcli/api/categoryApi.dart';
import 'package:discordcli/api/serverApi.dart';
import 'package:discordcli/helper/late.dart';
import 'package:discordcli/models/channels.dart';
import 'package:discordcli/models/message.dart';
import 'package:discordcli/queryApi/create.dart';
import 'package:discordcli/api/usersApi.dart';
import 'package:discordcli/queryApi/get_all.dart';
import 'package:discordcli/logger/log.dart';

class ChannelApi {
  static late Channel channel;
  static Future<void> createChannel() async {
    print("Enter Channel Name");
    final channelName = stdin.readLineSync().toString();
    print("Enter channel type");
    final inputChannelType = stdin.readLineSync().toString();
    try {
      channelType channelT = channelType.values.byName(inputChannelType);
      await Create.createChannel(
          userId: UserApi.userId,
          categoryId: CategoryApi.categoryId,
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
    if (channel.channeltype.toString() == 'channelType.announcement') {
      if (!(ServerApi.server.relationWithUser == 'mod' ||
          ServerApi.server.relationWithUser == 'owner')) {
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
          messageText: messageText,
          channelId: channel.id,
          userId: UserApi.userId);
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
      final res = await GetAll.messages(channelId: channel.id);
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
      final channels = await GetAll.getAllChannelsCategory(
          categoryId: CategoryApi.categoryId);
      for (var i = 0; i < channels.length; i++) {
        allChannels.add(channels[i].channelName);
      }
      if (ServerApi.server.relationWithUser == 'mod' ||
          ServerApi.server.relationWithUser == 'owner') {
        if (!CategoryApi.isPublic) {
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
        await CategoryApi.addUserToPrivateCategory();
        return false;
      } else if (channelChosen == 'exit category') {
        return false;
      } else {
        for (var i = 0; i < channels.length; i++) {
          if (channels[i].channelName == channelChosen) {
            channel = channels[i];
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
