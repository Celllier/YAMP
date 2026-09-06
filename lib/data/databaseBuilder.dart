import 'package:path/path.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';


class DatabaseBuilder {

  late Database database;

  static String databaseName = 'song_database.db';

  static String getDatabaseSchema() {
    return """
      CREATE TABLE songs (
          id INTEGER PRIMARY KEY,
          path TEXT NOT NULL UNIQUE,
          title TEXT,
          artist TEXT,
          durationSeconds INTEGER,
          is_favorited INTEGER NOT NULL DEFAULT 0
      );

      CREATE TABLE playlists (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          created_at INTEGER NOT NULL
      );

      CREATE TABLE playlist_songs (
          playlist_id INTEGER NOT NULL,
          song_id INTEGER NOT NULL,
          position INTEGER NOT NULL,

          PRIMARY KEY (playlist_id, song_id),

          FOREIGN KEY (playlist_id)
              REFERENCES playlists(id)
              ON DELETE CASCADE,

          FOREIGN KEY (song_id)
              REFERENCES songs(id)
              ON DELETE CASCADE
      );
    """;
  }


   Future<void> init() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi; 

    await loadDatabase();
  }

  Future<void> loadDatabase() async {
    final path = join(
      await getDatabasesPath(),
      DatabaseBuilder.databaseName,
    );

    //await deleteDatabase(path);

    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) => 
        db.execute(DatabaseBuilder.getDatabaseSchema()),
    );  
  }



}