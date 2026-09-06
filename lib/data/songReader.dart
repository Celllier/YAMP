import 'dart:io';

import 'song.dart';
import 'package:audio_metadata_reader/audio_metadata_reader.dart';

//change to SongFileReader
class SongReader {

  static String? get userHome =>
    Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];

  static Future<List<Song>> fetchAvailableSongs() async {
    String pathToMusicDir = "$userHome/Music";
    final songDirectory = Directory(pathToMusicDir);

    List<Song> availableSongs = [];

    await for (final entry in songDirectory.list()) {
      if (entry is File) {
        availableSongs.add(getSong(entry.path));
      }
    }

    //needs to be a map
    return availableSongs;
  }

//for database population
  static Future<List<Song>> fetchUserLibrarySongs() async {
    String pathToMusicDir = "$userHome/Music";
    final songDirectory = Directory(pathToMusicDir);

    List<Song> availableSongs = [];

    await for (final entry in songDirectory.list()) {
      if (entry is File) {
        availableSongs.add(fetchUserSong(entry.path));
      }
    }

    return availableSongs;

  }

  static Song fetchUserSong(String path) {
    final file = File(path);
    final metadata = readMetadata(file, getImage: false);  

    Song song = Song(
      artist: metadata.artist ?? Song.unknown,
      title: metadata.title ?? Song.unknown,
      durationSeconds: metadata.duration?.inSeconds ?? 0,
      //albumArt: songImage,
      sourcePath: file.path
    );

    return song;
  }

  static Song getSong(String path) {
    final file = File(path);
    final metadata = readMetadata(file, getImage: true);

    SongImage songImage = metadata.pictures.isNotEmpty 
      ? SongByteImage(bytes:metadata.pictures[0].bytes) 
      : Song.defaultAlbumArt;

    Song song = Song(
      artist: metadata.artist ?? Song.unknown,
      title: metadata.title ?? Song.unknown,
      durationSeconds: metadata.duration?.inSeconds ?? 0,
      albumArt: songImage,
      sourcePath: file.path
    );

    return song;
  }


  static String removeAssetPrefix(String path) {
    return path.substring(path.indexOf('/') + 1);
  }
}


class SongFileEntry {

  //Map<String, Object?> toMap() {
  //  return {'id': id, 'name': name, 'age': age};
  //}

}