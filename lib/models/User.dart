import 'package:crypt/crypt.dart';
import 'dart:io';

class User {
  String username = '';
  String password = '';

  User({
    required String usrname,
    required String pass,
  }) {
    username = usrname;
    password = pass;
  }

  String hashPwd({required String pass}) {
    return Crypt.sha256(pass, rounds: 1000).toString();
  }

  bool comparePwd({required String passValue}) {
    final hashPwd = Crypt(password);
    return hashPwd.match(passValue);
  }

  static User fromMap(Map<String, dynamic> map) => User(
        usrname: map["username"].toString(),
        pass: map["password"].toString(),
      );
  Map<String, String> toMap(List values) =>
      {"id": values[0], "username": values[1], "password": values[2]};

  User.fromList(List<dynamic> list) {
    username = list[0][1];
    password = list[0][2];
  }

  @override
  String toString() {
    print(username);
    return super.toString();
  }
}
