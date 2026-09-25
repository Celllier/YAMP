import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yamp/data/metadata.dart';
import 'package:yamp/data/songRepository.dart';

class Song extends ChangeNotifier {

  static const String unknown = "Unknown";
  static const SongPathImage defaultAlbumArt = SongPathImage(path: "assets/albums/arvores.jpg");
  static const String deafultSourcePath = "songs/Starlight.mp3";

  Song ({
    required this._artist,
    required this._title, 
    required this._durationSeconds, 
    this._albumArt = Song.defaultAlbumArt,
    this._sourcePath = Song.deafultSourcePath,
    this._favorited = false,
    this._id,
  });

  Song.fromEntry(Map<String, Object?> dbEntry) : this 
    (
      id: dbEntry['id'] as int,
      artist: dbEntry['artist'] as String, 
      title: dbEntry['title'] as String, 
      durationSeconds: dbEntry['durationSeconds'] as int,
      sourcePath: dbEntry['path'] as String,
      favorited: dbEntry['is_favorited'] as int == 0 ? false : true,
    );

  Map<String, Object?> toMap() {
    return {
      'artist': _artist,
      'title': _title, 
      'durationSeconds': _durationSeconds,
      'path': _sourcePath,
      'is_favorited': _favorited ? 1 : 0,
    };
  }

  void toggleFavorite() {
    if (_favorited) {
      _favorited = false;
    } else {
      _favorited = true;
    }
  }

  void setImage(SongImage songImage) {
    _albumArt = songImage;
  }

  void updateMetadata(Metadata metadata) {
    if (Metadata.isNonEmpty(metadata.title)) {
      _title = metadata.title!;
    }  

    if (Metadata.isNonEmpty(metadata.artist)) {
      _artist = metadata.artist!;
    }  

    notifyListeners();
  }
 
  @override
  bool operator ==(Object other) {
    return other is Song && other._sourcePath == _sourcePath;
  }

  @override
  String toString() {
    return """
      - title: $_title \n
      - artist: $_artist \n
    """;
  }

  int? _id;
  String _artist;
  String _title;
  final int _durationSeconds;
  SongImage _albumArt;
  final String _sourcePath;
  bool _favorited;

  int? get id => _id;
  String get artist => _artist;
  String get title => _title;
  int get durationSeconds => _durationSeconds;
  String get sourcePath => _sourcePath;
  bool get isFavorited => _favorited;

  SongImage get albumArt => _albumArt;
  
}


class SongModel extends ChangeNotifier {

  SongModel({required this._songRepository}) {
    _loadSongs();
  }

  final SongRepository _songRepository;

  List<Song> _loadedSongs = [];
  final Map<int, Song> _songMap = {};

  Future<void> _loadSongs() async {
    _loadedSongs = await _songRepository.loadSongs();
    _loadMap();
    notifyListeners();
  }

  void _loadMap() {
    for (final song in _loadedSongs) {
      _songMap.putIfAbsent(song.id!, () => song);
    }
  }

  Future<void> saveSong(Song song) async {
    await _songRepository.updateSong(song);
    notifyListeners();
  }

  Song fetchSong(int id) {
    return _songMap[id]!;
  }

  List<Song> fetchSongs(List<int> ids) {
    final List<Song> songs = [];
    for (final int id in ids) {
      if (_songMap.containsKey(id)) {
        songs.add(_songMap[id]!);
      }
    }
    return songs;
  }

  List<int> getAllSongIds() {
    return _songMap.keys.toList();
  }


  List<Song> get availableSongs => _loadedSongs;
}




abstract class SongImage {

  const SongImage();

  ImageProvider get imageProvider;

  Widget displayImage({double size = 60}) {
    return SizedBox.square(
      dimension: size,
      child: ClipRRect(
        child: Image(
          image: imageProvider,
          fit: BoxFit.cover
        ),
      ),
    );
  }
}


class SongPathImage extends SongImage {

  const SongPathImage({required this.path});

  final String path;

  @override
  ImageProvider get imageProvider => AssetImage(path);
}


class SongByteImage extends SongImage {

  SongByteImage({required this.bytes});

  final Uint8List bytes;

  @override
  ImageProvider get imageProvider => MemoryImage(bytes);
}