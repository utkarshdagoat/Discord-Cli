import 'package:crypt/crypt.dart';
import 'package:uuid/uuid.dart';

final uuid = Uuid();

class Session {
  String sessionKey = uuid.v4();
  late String sessionData;

  Session({required String username}) {
    sessionData = Crypt.sha256(username, rounds: 1000).toString();
  }
}
