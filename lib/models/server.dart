class Server {
  late int id;
  late String serverName;
  late String relationWithUser;

  Server(
      {required int id,
      required String serverName,
      required String realtionWithUser}) {
    this.id = id;
    this.serverName = serverName;
    this.relationWithUser = realtionWithUser;
  }

  static Server fromSeverOwnerTable({required List<dynamic> response}) =>
      Server(
          id: response[0], serverName: response[1], realtionWithUser: 'owner');
  static Server fromSeverModTable({required List<dynamic> response}) =>
      Server(id: response[0], serverName: response[1], realtionWithUser: 'mod');
  static Server fromSeverUserTable({required List<dynamic> response}) => Server(
      id: response[0], serverName: response[1], realtionWithUser: 'user');
}
