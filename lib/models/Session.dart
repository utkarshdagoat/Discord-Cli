import 'package:crypt/crypt.dart';
import 'package:discordcli/api/usersApi.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

final uuid = Uuid();

class Session {
  String sessionKey = uuid.v4();
  late int user_id;

  Session({required int user_id}) {
    this.user_id = user_id;
  }
}
