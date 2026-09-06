import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'song.dart';
import 'songReader.dart';

class SongRepository {

  late Database database;

  static const String songsTable = "songs";  

  static String getDatabasesSchema() {
    return """
      CREATE TABLE songs (
          id INTEGER PRIMARY KEY,
          path TEXT NOT NULL UNIQUE,
          title TEXT,
          artist TEXT,
          durationSeconds INTEGER
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

  Future<void> loadDatabase() async {
    final path = join(
      await getDatabasesPath(),
      'song_database.db',
    );

    await deleteDatabase(path);

    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) => 
        db.execute(SongRepository.getDatabasesSchema()),
    );  
  }


  Future<void> insertIfNotPresent(Song song) async {
    await database.insert(
      SongRepository.songsTable, 
      song.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  } 

  Future<void> populateWithUserSongs() async {
    List<Song> userSongs = await SongReader.fetchUserLibrarySongs();

    for (final song in userSongs) {
      await insertIfNotPresent(song);
    }
  }

  Future<List<Song>> loadSongs({int limit = 10}) async {

    final List<Map<String, Object?>> songMaps = await database.query(
      SongRepository.songsTable,
      limit: limit,
    );

    print(songMaps);

    return [
      for (final entry in songMaps) 
        Song.fromEntry(entry)
    ];

    //return [
    //  for (final {'artist': artist as String, 'title': title as String, 'durationSeconds': durationSeconds as int} in songMaps) 
    //    Song(artist: artist, title: title, durationSeconds: durationSeconds)
    //];  


  }

  void loadPlaylists() {
    
  }
  
}