
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'songReader.dart';

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

  final String _artist;
  final String _title;
  final int _durationSeconds;
  final SongImage _albumArt;
  final String _sourcePath;

  String get artist => _artist;
  String get title => _title;
  int get durationSeconds => _durationSeconds;
  //String get albumArtPath => _albumArtPath;
  String get sourcePath => _sourcePath;

  Widget get imageWidget => _albumArt.displayImage();
  
}


//  Song(artist: 'Dean Blunt', title: 'Babyfather Freestyle', durationSeconds: 128, albumArtPath: "assets/albums/olho.jpg", sourcePath: "songs/snakeman_freestyle.mp3"),
//  Song(artist: 'King Krule', title: 'Easy Easy', durationSeconds: 196, albumArtPath: "assets/albums/6ft.jpeg", sourcePath: 'songs/EasyEasy.mp3'),
//  Song(artist: 'Alex G', title: 'Written in Blood', durationSeconds: 250, albumArtPath: "assets/albums/writtenInBlood.jpeg"),
//  Song(artist: 'Duster', title: 'Stratosphere', durationSeconds: 100),
//  Song(artist: 'Sweet Trip', title: 'Chocolate', durationSeconds: 265, albumArtPath: "assets/albums/silent.jpg"),
//];



final List<Song> _favorites = []; 


class SongModel extends ChangeNotifier {

  SongModel() {
    _loadSongs();
  }

  List<Song> _availableSongs = [];



  Future<void> _loadSongs() async {
    _availableSongs = await SongReader.fetchAvailableSongs();
    notifyListeners();
  }

  List<Song> get availableSongs => _availableSongs;
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