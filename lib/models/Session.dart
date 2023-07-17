import 'package:uuid/uuid.dart';

final uuid = Uuid();

class Session {
  String sessionKey = uuid.v4();
  late int user_id;

  Session({required int user_id}) {
    this.user_id = user_id;
  }
}
