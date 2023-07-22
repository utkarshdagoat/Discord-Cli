class DeleteSql {
  static const String deleteSession =
      '''DELETE FROM sessions WHERE user_id=@user_id ''';

  static const String deleteServerUserRelation =
      '''DELETE FROM server_users WHERE server_name=
  @server_name AND user_id=@mod_id''';
}
