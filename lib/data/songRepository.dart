import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'song.dart';
import 'songFileReader.dart';

class SongRepository {

  static const String songsTable = "songs";  

  SongRepository({
    required this._database
  }) {
    init();
  }
 
  final Database _database;


  Future<void> init() async {
    await populateWithUserSongs();
  }


  Future<void> insertIfNotPresent(Song song) async {
    await _database.insert(
      SongRepository.songsTable, 
      song.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,

    );
  } 

  Future<void> populateWithUserSongs() async {
    List<Song> userSongs = await SongFileReader.fetchUserLibrarySongs();
    for (final song in userSongs) {
      await insertIfNotPresent(song);
    }
  }

  Future<List<Song>> loadSongs({int limit = 10}) async {
    final List<Map<String, Object?>> songMaps = await _database.query(
      SongRepository.songsTable,
      limit: limit,
    );

    print(songMaps);

    return [
      for (final entry in songMaps) 
        Song.fromEntry(entry)
    ];
  }


  Future<void> favoriteSong(Song song) async {
    _database.update(
      SongRepository.songsTable,
      song.toMap(),
      where: 'id = ?',
      whereArgs: [song.id!]
    );
  }

  void loadPlaylists() {
    
  }
  
}