import 'package:discordcli/api/serverApi.dart';
import 'package:discordcli/api/usersApi.dart';
import 'package:discordcli/logger/log.dart';
import 'dart:io';

import 'package:discordcli/queryApi/create.dart';
import 'package:discordcli/queryApi/get_all.dart';
import 'package:discordcli/queryApi/get_params.dart';
import 'package:discordcli/queryApi/validation.dart';

class CategoryApi {
  static late bool isPublic;
  static late int categoryId;

  static Future<void> createCategory() async {
    print('Enter the following');
    Logs.logger.info('Category Name:\n');
    final categoryName = stdin.readLineSync().toString();
    final input =
        Logs.logger.chooseOne('Is the channel public', choices: ['Yes', 'No']);
    if (input == 'No') isPublic = false;
    try {
      int categoryId = await Create.creatBaseCategory(
          categoryName: categoryName,
          serverId: ServerApi.server.id,
          isPublic: isPublic);
      if (!isPublic) {
        await Create.creatProtectedCategory(
            categoryId: categoryId, userId: UserApi.userId);
      }
      Logs.logger.success('\n Category succefully created');
    } catch (e) {
      print(e);
      return;
    }
  }

  static Future<void> addUserToPrivateCategory() async {
    print('Enter the following');
    Logs.logger.info('Username:\n');
    String username = stdin.readLineSync().toString();
    try {
      int userId =
          (await GetByParams.getUserByUsername(username: username))["id"];
      await Create.creatProtectedCategory(
          categoryId: categoryId, userId: userId);
      Logs.logger.success('\n User succefully added');
    } catch (e) {
      print(e);
      return;
    }
  }

  static Future<bool> showCategories() async {
    List<String> allCategories = [];
    try {
      final categories =
          await GetAll.getAllCategoriesOfServer(serverId: ServerApi.server.id);
      for (var i = 0; i < categories.length; i++) {
        if (!categories[i].isPublic) {
          if (await ValidationApi.isAllowedToSeeCategory(
              categoryId: categories[i].categoryId, userId: UserApi.userId)) {
            allCategories.add(categories[i].categoryName);
          }
        } else {
          allCategories.add(categories[i].categoryName);
        }
      }
      if (ServerApi.server.relationWithUser == 'mod' ||
          ServerApi.server.relationWithUser == 'owner') {
        allCategories.add('create category');
      }
      if (ServerApi.server.relationWithUser == 'owner') {
        allCategories.add('make mod');
      }
      allCategories.add('<-');
      final categoryChoosen = Logs.logger.chooseOne(
          'Choose one of the following category',
          choices: allCategories);
      if (categoryChoosen == 'create category') {
        await createCategory();
        return false;
      } else if (categoryChoosen == 'make mod') {
        await ServerApi.makeMod();
        return false;
      } else if (categoryChoosen == '<-') {
        return false;
      } else {
        for (var i = 0; i < categories.length; i++) {
          if (categories[i].categoryName == categoryChoosen) {
            isPublic = categories[i].isPublic;
            categoryId = categories[i].categoryId;
            return true;
          }
        }
        print('No such category');
        return false;
      }
    } catch (e) {
      print(e);
      exit(11);
    }
  }
}
