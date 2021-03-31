// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  NewsDao _newsDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `news` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `url` TEXT, `urlToImage` TEXT, `title` TEXT, `author` TEXT, `date` TEXT, `desc` TEXT, `themeNames` TEXT, `content` TEXT)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  NewsDao get newsDao {
    return _newsDaoInstance ??= _$NewsDao(database, changeListener);
  }
}

class _$NewsDao extends NewsDao {
  _$NewsDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _newsInsertionAdapter = InsertionAdapter(
            database,
            'news',
            (News item) => <String, dynamic>{
                  'id': item.id,
                  'url': item.url,
                  'urlToImage': item.urlToImage,
                  'title': item.title,
                  'author': item.author,
                  'date': item.date,
                  'desc': item.desc,
                  'themeNames': item.themeNames,
                  'content': item.content
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<News> _newsInsertionAdapter;

  @override
  Future<List<News>> getNewsByThemeId(String themeId) async {
    return _queryAdapter.queryList('select * from news where themeId like ?',
        arguments: <dynamic>[themeId],
        mapper: (Map<String, dynamic> row) => News(
            row['id'] as int,
            row['url'] as String,
            row['urlToImage'] as String,
            row['title'] as String,
            row['author'] as String,
            row['date'] as String,
            row['desc'] as String,
            row['themeNames'] as String,
            content: row['content'] as String));
  }

  @override
  Future<List<News>> getAll() async {
    return _queryAdapter.queryList('select * from news',
        mapper: (Map<String, dynamic> row) => News(
            row['id'] as int,
            row['url'] as String,
            row['urlToImage'] as String,
            row['title'] as String,
            row['author'] as String,
            row['date'] as String,
            row['desc'] as String,
            row['themeNames'] as String,
            content: row['content'] as String));
  }

  @override
  Future<void> delete(int newsId) async {
    await _queryAdapter.queryNoReturn('delete from news where id = ?',
        arguments: <dynamic>[newsId]);
  }

  @override
  Future<void> insertOne(News news) async {
    await _newsInsertionAdapter.insert(news, OnConflictStrategy.replace);
  }
}
