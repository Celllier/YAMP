import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yamp/data/playlist.dart';
import 'package:yamp/data/song.dart';

class Utils {
  static String formatDuration(int seconds) {
    String min = "${(seconds / 60).floor()}";
    int isec = seconds % 60;
    String sec = isec < 10 ? "0$isec" : "$isec";

    return "$min:$sec";
  }

  static String formatDurationHours(int seconds) {
    int hour = (seconds / 3600).floor();
    int min = ((seconds%3600)/60).floor();
    if (hour == 0) {
      return "${min} mins";
    }
    return "${hour}hours ${min}mins";
  }


  static Widget buildLeadingPlaylistArt(BuildContext context, Playlist playlist, {double size = 80}) {
    if (playlist.length == 0) {
      return Song.defaultAlbumArt.displayImage(size: size);
    }

    if (playlist.length < 4) {
      Song song = playlist.getFirstSong(context.read<SongModel>());
      return song.albumArt.displayImage(size: size);
    } 

    List<Song> firstFourSongs = playlist.getFirstFourSongs(context.read<SongModel>());
    double smallSize = size/2;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            firstFourSongs[0].albumArt.displayImage(size: smallSize),
            firstFourSongs[1].albumArt.displayImage(size: smallSize)
          ]
        ),

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            firstFourSongs[2].albumArt.displayImage(size: smallSize),
            firstFourSongs[3].albumArt.displayImage(size: smallSize)
          ]
        ),
      ],
    );
  }
}