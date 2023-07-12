import 'package:crypt/crypt.dart';

class User {
  late String username = '';
  late String password = '';
  String _tablename = "users";
  User({
    required String usrname,
    required String pass,
  }) {
    username = usrname;
    password = pass;
  }
  String get tablename {
    return this._tablename;
  }

  String hashPwd({required String pass}) {
    return Crypt.sha256(pass, rounds: 1000).toString();
  }

  bool ComparePwd({required String passValue}) {
    final hashPwd = Crypt(password);
    return hashPwd.match(passValue);
  }

  static User fromMap(Map<String, dynamic> map) => User(
        usrname: map["username"].toString(),
        pass: map["password"].toString(),
      );
  static Map<String, String> toMap(List values) {
    return {"id": values[0], "username": values[1], "password": values[2]};
  }
}
