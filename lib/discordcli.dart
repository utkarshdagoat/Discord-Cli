import 'dart:io';

Map<String, String?> get_user_input() {
  List<String> fields = ["username", "password"];
  Map<String, String?> userInfo = {};
  for (final field in fields) {
    print("Enter $field");
    userInfo[field] = stdin.readLineSync();
  }
  return userInfo;
}
