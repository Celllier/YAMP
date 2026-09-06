import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yamp/data/songRepository.dart';

class Song {

  static const String unknown = "Unknown";
  static const SongPathImage defaultAlbumArt = SongPathImage(path: "assets/albums/arvores.jpg");
  static const String deafultSourcePath = "songs/Starlight.mp3";

  Song ({
    required this._artist,
    required this._title, 
    required this._durationSeconds, 
    this._albumArt = Song.defaultAlbumArt,
    this._sourcePath = Song.deafultSourcePath,
  });

  Song.fromEntry(Map<String, Object?> dbEntry) : this 
    (
      artist: dbEntry['artist'] as String, 
      title: dbEntry['title'] as String, 
      durationSeconds: dbEntry['durationSeconds'] as int,
      sourcePath: dbEntry['path'] as String,
    );

  Map<String, Object?> toMap() {
    return {
      'artist': _artist,
      'title': _title, 
      'durationSeconds': _durationSeconds,
      'path': _sourcePath,
    };
  }

  int? id;
  final String _artist;
  final String _title;
  final int _durationSeconds;
  final SongImage _albumArt;
  final String _sourcePath;

  String get artist => _artist;
  String get title => _title;
  int get durationSeconds => _durationSeconds;
  String get sourcePath => _sourcePath;

  Widget get imageWidget => _albumArt.displayImage();
  
}


class Playlist extends ChangeNotifier {

  final Queue<Song> _queue = Queue();

  final String _name = "Default playlist";

  void add(Song song) {
    _queue.add(song);
    notifyListeners();
  } 

  void remove(Song song) {
    _queue.remove(song);
    notifyListeners();
  }

  String get name => _name;
}




class SongModel extends ChangeNotifier {

  SongModel({required this.songRepository}) {
    _loadSongs();
  }

  final SongRepository songRepository;

  List<Song> _loadedSongs = [];
  final List<Song> _favorites = []; 

  // need playlist loader
  final List<Playlist> _loadedPlaylists = [
    Playlist(),
    Playlist(),
  ];

  List<Playlist> get playlists => _loadedPlaylists;


  //_loadedSongs = await SongReader.fetchAvailableSongs();
  Future<void> _loadSongs() async {
    _loadedSongs = await  songRepository.loadSongs();
    print(_loadedSongs);
    notifyListeners();
  }

  List<Song> get availableSongs => _loadedSongs;
  List<Song> get favorites => _favorites;

  bool isInFavorites(Song song) {
    return _favorites.contains(song);
  }

  void addToFavorite(Song song) {
    _favorites.add(song);
    notifyListeners();
  }

  void removeFromFavorite(Song song) {
    if (_favorites.contains(song)) {
      _favorites.remove(song);
    }
    notifyListeners();
  }

  void clearFavorites() {
    _favorites.clear();
    notifyListeners();
  }
}




abstract class SongImage {

  const SongImage();

  Widget displayImage() {
    return AspectRatio(
      aspectRatio: 1/1,
      child: createImage(),
    );
  }

  Widget createImage();
}


class SongPathImage extends SongImage {

  const SongPathImage({required this.path});

  final String path;

  @override
  Widget createImage() {
    return Image(
      image: AssetImage(path),
      fit: BoxFit.fitWidth
    );
  }
}


class SongByteImage extends SongImage {

  SongByteImage({required this.bytes});

  final Uint8List bytes;

  @override
  Widget createImage() {
    return Image.memory(
      bytes,
      fit: BoxFit.fitWidth
    );
  }


}