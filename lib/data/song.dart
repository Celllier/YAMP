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

  @override
  bool operator ==(Object other) {
    return other is Song && other._sourcePath == _sourcePath;
  }

  @override
  String toString() {
    return "${_title} - isFavorited: ${isFavorited}";
  }

  int? _id;
  final String _artist;
  final String _title;
  final int _durationSeconds;
  final SongImage _albumArt;
  final String _sourcePath;
  bool _favorited;

  int? get id => _id;
  String get artist => _artist;
  String get title => _title;
  int get durationSeconds => _durationSeconds;
  String get sourcePath => _sourcePath;
  bool get isFavorited => _favorited;

  Widget get imageWidget => _albumArt.displayImage();
  
}


class SongModel extends ChangeNotifier {

  SongModel({required this._songRepository}) {
    _loadSongs();
  }

  final SongRepository _songRepository;

  List<Song> _loadedSongs = [];

  Future<void> _loadSongs() async {
    _loadedSongs = await _songRepository.loadSongs();
    notifyListeners();
  }


  List<Song> get availableSongs => _loadedSongs;
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