import 'package:discordcli/logger/log.dart';
import 'package:discordcli/models/User.dart';
import 'package:discordcli/models/server.dart';
import 'dart:io';
import 'package:discordcli/queryApi/create.dart';
import 'package:discordcli/queryApi/get_all.dart';
import 'package:discordcli/queryApi/get_params.dart';
import 'package:discordcli/queryApi/validation.dart';

class Category {
  static late int categoryId;
  static late String categoryName;
  static late bool isPublic;

  Category(int id, String name, bool isPu) {
    categoryId = id;
    categoryName = name;
    isPublic = isPu;
  }
  get categoryNameGetter => categoryName;
  get categoryIdGetter => categoryId;
  get isPublicGetter => isPublic;

  static Category fromResponse({required List<dynamic> response}) =>
      Category(response[0], response[1], response[2]);

  static Future<void> createCategory() async {
    print('Enter the following');
    Logs.logger.info('Category Name:\n');
    final categoryName = stdin.readLineSync().toString();
    final input =
        Logs.logger.chooseOne('Is the channel public', choices: ['Yes', 'No']);
    if (input == 'No') isPublic = false;
    try {
      int categoryId = await Create.creatBaseCategory(
          categoryName: categoryName, serverId: Server.id, isPublic: isPublic);
      if (!isPublic) {
        await Create.creatProtectedCategory(
            categoryId: categoryId, userId: User.userId);
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
          await GetAll.getAllCategoriesOfServer(serverId: Server.id);
      for (var i = 0; i < categories.length; i++) {
        if (!categories[i].isPublicGetter) {
          if (await ValidationApi.isAllowedToSeeCategory(
              categoryId: categories[i].categoryIdGetter,
              userId: User.userId)) {
            allCategories.add(categories[i].categoryNameGetter);
          }
        } else {
          allCategories.add(categories[i].categoryNameGetter);
        }
      }
      if (Server.relationWithUser == 'mod' ||
          Server.relationWithUser == 'owner') {
        allCategories.add('create category');
      }
      if (Server.relationWithUser == 'owner') {
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
        await Server.makeMod();
        return false;
      } else if (categoryChoosen == '<-') {
        return false;
      } else {
        for (var i = 0; i < categories.length; i++) {
          if (categories[i].categoryNameGetter == categoryChoosen) {
            isPublic = categories[i].isPublicGetter;
            categoryId = categories[i].categoryIdGetter;
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
