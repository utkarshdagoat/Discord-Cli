class SqlGetByParams {
  static const String USERBYUSERNAME = '''
      SELECT * FROM users WHERE username=@username
    ''';

  static const String IDBYSERVERNAME =
      ''' SELECT id FROM servers WHERE server_name=@server_name''';
  static const String channelBychannelName =
      '''SELECT * FROM channels WHERE channel_name=@channel_name AND server_name=@server_name''';
  static const String userNameById =
      '''SELECT username FROM users WHERE id=@id''';
  static const String serverByserverName =
      '''SELECT id FROM servers WHERE server_name=@server_name''';
}
