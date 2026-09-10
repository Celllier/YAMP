import 'dart:collection';

import 'package:sqflite/sqflite.dart';
import 'package:yamp/data/playlist.dart';

import 'song.dart';
import 'songFileReader.dart';

class SongRepository {

  static const String songsTable = "songs";  
  static const String playlistTable = "playlists";
  static const String playlistSongsTable = "playlist_songs";

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


  Future<void> toggleFavorite(Song song) async {
    await _database.update(
      SongRepository.songsTable,
      song.toMap(),
      where: 'id = ?',
      whereArgs: [song.id!]
    );
  }


  Future<void> toggleFavoriteVal(Song song, bool newValue) async {
    final value = {'is_favorited': newValue ? 1 : 0};
    await _database.update(
      SongRepository.songsTable,
      value,
      where: 'id = ?',
      whereArgs: [song.id!]
    );
  }


  Future<Set<int>> fetchFavoritesIds({int limit = 10, int offset = 0}) async {
    final List<Map<String, Object?>> songMaps = await _database.query(
      SongRepository.songsTable,
      where: 'is_favorited = 1',
      limit: limit,
      offset: offset,
    );

    Set<int> ids = {};

    for (final entry in songMaps) {
      ids.add(entry['id'] as int); 
    }
    
    return ids;

  }

  Future<List<Playlist>> loadPlaylists({int limit = 10, int offset = 0}) async {
    final List<Map<String, Object?>> playlistMaps = await _database.query(
      SongRepository.playlistTable,
      limit: limit,
      offset: offset,
    );

    List<Playlist> playlists = [];
    for (final entry in playlistMaps) {
      playlists.add(Playlist(
        name: entry['name'] as String,
        id: entry['id'] as int,
        songRepository: this,
      ));
    }

    return playlists;
  }


  Future<Playlist> createPlaylist(String name) async {
    final int now = DateTime.now().millisecondsSinceEpoch;
    Map<String, Object?> map = {'name': name, 'created_at': now};

    int id = await _database.insert(
      SongRepository.playlistTable, 
      map
    );

    return Playlist(name: name, id: id, songRepository: this);
  }

  Future<Queue<int>> loadPlaylistSongs({required int playlistId}) async {
    final List<Map<String, Object?>> map = await _database.query(
      SongRepository.playlistSongsTable,
      where: 'playlist_id = ?',
      whereArgs: [playlistId],
      orderBy: 'position',
    );

    Queue<int> queue = Queue();

    for (final entry in map) {
      queue.add(entry['song_id'] as int);
    }

    return queue;
  }
  
}