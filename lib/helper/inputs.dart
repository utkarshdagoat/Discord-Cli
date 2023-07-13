import "package:discordcli/helper/fields.dart";
import 'dart:io';

mixin BaseInput {
  static Map<String, dynamic> get_inputs(Type cls) {
    Map<String, dynamic> mappedInputs = {};
    final fields = get_all_fields(cls);
    print("Enter the following");
    for (final field in fields) {
      print("$field:");
      final input = stdin.readLineSync();
      mappedInputs.addAll({field: input});
    }
    return mappedInputs;
  }
}
