import 'dart:io';

import 'song.dart';
import 'package:audio_metadata_reader/audio_metadata_reader.dart';

class SongReader {

  // need to make this less hardcoded
  static String pathToSongs = '/home/micael/Music';

  static Future<List<Song>> fetchAvailableSongs() async {
    final songDirectory = Directory(SongReader.pathToSongs);

    List<Song> availableSongs = [];

    await for (final entry in songDirectory.list()) {
      if (entry is File) {
        availableSongs.add(getSong(entry.path));
      }
    }

    return availableSongs;
  }

//'assets/songs/EasyEasy.mp3'
  static Song getSong(String path) {
    final file = File(path);
    final metadata = readMetadata(file, getImage: true);

    SongImage songImage = metadata.pictures.isNotEmpty 
      ? SongByteImage(bytes:metadata.pictures[0].bytes) 
      : Song.defaultAlbumArt;

    print(metadata);


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