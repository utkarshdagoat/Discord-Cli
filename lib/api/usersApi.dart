//This file contains the user endpoints like register user , logout user
//session creation logic
import "package:discordcli/helper/inputs.dart";
import 'package:discordcli/models/User.dart';
import 'package:discordcli/queryApi/create.dart';

class UserApi with BaseInput {
  static Future<User> register() async {
    Map<String, dynamic> inputs = BaseInput.get_inputs(User);
    return await Create.createUser(inputs);
  }

  //todo
  /* static Future<User> login() async {
    Map<String, dynamic> inputs = BaseInput.get_inputs(User);

  } */
}
