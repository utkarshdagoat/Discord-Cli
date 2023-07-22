class SqlTables {
  SqlTables._();
  static const String USERS = '''
    CREATE TABLE IF NOT EXISTS users(
      id serial PRIMARY KEY,
      username text,
      password text
    )''';

  static const String SESSIONS = '''
    CREATE TABLE IF NOT EXISTS sessions (
      id serial PRIMARY KEY,
      sessionkey text not null,
      user_id integer REFERENCES users(id) UNIQUE 
    )
''';

  static const String SERVERS = '''
      CREATE TABLE IF NOT EXISTS servers (
        id serial PRIMARY KEY,
        server_name text not null UNIQUE,
        owner_id integer REFERENCES users(id)  
      )
  ''';

  static const String SERVER_USERS = '''
      CREATE TABLE IF NOT EXISTS server_users (
        server_id integer REFERENCES servers(id),
        server_name text REFERENCES servers(server_name),
        user_id integer REFERENCES users(id),
        PRIMARY KEY (server_name , user_id)  
      )
  ''';
  static const String SERVER_MODS = '''
      CREATE TABLE IF NOT EXISTS server_mods (
        server_id integer REFERENCES servers(id),
        server_name text REFERENCES servers(server_name),
        mod_id integer REFERENCES users(id),
        PRIMARY KEY (mod_id)  
      )
  ''';

  static const String CATEGORIES = '''
      CREATE TABLE IF NOT EXISTS categories(
        id serial PRIMARY KEY,
        category_name text not null,
        isPublic bool,
        server_id integer REFERENCES servers(id) 
      )
  ''';
  static const String PRIVATE_CATEGORY_USERS = '''
      CREATE TABLE IF NOT EXISTS category_private_users (
        id serial PRIMARY KEY,
        allowed_user integer   REFERENCES users(id),
        category_id integer REFERENCES categories(id)
      )
  ''';

  static const String CHANNELS = '''
      CREATE TABLE IF NOT EXISTS channels (
        id serial PRIMARY KEY,
        channel_name text not null,
        channel_type text not null,
        category_id integer REFERENCES categories(id)  
      )
  ''';

  static const String CHANNELS_MESSAGE = '''
      CREATE TABLE IF NOT EXISTS message_channel (
        id serial PRIMARY KEY,
        channel_id integer REFERENCES channels(id),
        sender integer REFERENCES users(id),
        message text not null,
        time_sent timestamp DEFAULT localtimestamp NOT NULL
      )
  ''';

  static const String DM_MESSAGE = '''
      CREATE TABLE IF NOT EXISTS message_dm (
        id serial PRIMARY KEY,
        to_send integer REFERENCES users(id),
        sender integer REFERENCES users(id),
        message text not null,
        time_sent timestamp DEFAULT localtimestamp NOT NULL
      )
  ''';

  static const List<String> queries = [
    USERS,
    SESSIONS,
    SERVERS,
    SERVER_MODS,
    SERVER_USERS,
    CATEGORIES,
    PRIVATE_CATEGORY_USERS,
    CHANNELS,
    CHANNELS_MESSAGE,
    DM_MESSAGE
  ];
}
