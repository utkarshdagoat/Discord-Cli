class SqlGetAll {
  static const getChannelMessages =
      '''SELECT * FROM message_channel WHERE channel_id=@channel_id ORDER BY time_sent DESC LIMIT 10''';
  static const getDmMessages =
      '''SELECT * FROM message_dm WHERE to_send=@user_id ORDER BY time_sent DESC LIMIT 10''';
  static const getServerWhereOwner =
      '''SELECT * FROM servers WHERE owner_id=@user_id''';
  static const getServerWhereMod =
      '''SELECT * FROM server_mods WHERE mod_id=@user_id''';
  static const getServerWhereUser =
      '''SELECT * FROM server_users WHERE user_id=@user_id''';
  static const getCategoryOfServer =
      '''SELECT * FROM categories WHERE server_id=@server_id''';
  static const getChannelsofCategories =
      '''SELECT * FROM channels WHERE category_id=@category_id''';
  static const validationForSeeingcategories = '''
      SELECT * FROM category_private_users WHERE allowed_user=@user_id AND category_id=@category_id
    ''';
  static const String serverFromServerName = '''
      SELECT * FROM servers WHERE server_name=@server_name
    ''';
  static const String userIdFromServerUser =
      '''SELECT user_id FROM server_users WHERE server_name=@server_name''';
  static const String modIdFromServerMods =
      '''SELECT mod_Id FROM server_mods WHERE server_name=@server_name''';

  static const String ownerIdFromServer =
      '''SELECT owner_id FROM servers WHERE server_name=@server_name''';
  static const sessionsByUserId = '''
      SELECT * FROM sessions WHERE user_id=@user_id
    ''';
}
