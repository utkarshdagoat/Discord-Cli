class sqlCreate {
  sqlCreate._();
  static const USERS = '''
    INSERT INTO users (username , password ) 
    VALUES (@username, @password) returning id
    ''';
  static const String SESSIONS = '''
    INSERT INTO sessions (sessionkey , user_id)
    VALUES( @sessionkey , @user_id)
    ''';

  static const String SERVERS = '''
    INSERT INTO servers (server_name , owner_id )
    VALUES (@server_name , @owner_id)
    ''';

  static const String SERVER_USERS = '''
    INSERT INTO server_users (server_id , user_id ,  server_name)
    VALUES (@server_id , @user_id , @server_name)
    ''';

  static const String SERVER_MODS = '''
    INSERT INTO server_mods (server_id , server_name , mod_id )
    VALUES (@server_id , @server_name , @mod_id) 
    ''';

  static const String CHANNELS = '''
    INSERT INTO channels (channel_name , channel_type ,  category_id)
    VALUES (@channel_name , @channel_type , @category_id) RETURNING *
    ''';

  static const String CHANNELS_MESSAGE = '''
    INSERT INTO message_channel (channel_id , sender , message)
    VALUES (@channel_id , @sender , @message)
    ''';
  static const String DM_MESSAGE = '''
    INSERT INTO message_dm (to_send , sender , message)
    VALUES (@to_send , @sender , @message)
    ''';

  static const String CATEGORY = '''
    INSERT INTO categories (category_name ,  isPublic ,server_id)
    VALUES (@category_name , @isPublic , @server_id) RETURNING id
''';
  static const String CATEGORY_PROTECTED = '''
      INSERT INTO  category_private_users (allowed_user , category_id)
      VALUES (@user_id , @category_id)
  ''';
}
