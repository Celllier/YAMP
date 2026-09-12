import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';

import 'common/common.dart';
import 'common/miniPlayer.dart';
import 'common/songSlider.dart';
import 'common/button/favoriteIcon.dart';
import 'common/button/queueButton.dart';
import '../data/song.dart';

import '../data/songPlayer.dart';


class SongPage extends StatelessWidget {

  const SongPage({super.key, required this.song});

  final Song song;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: song.title, automaticallyImplyLeading: true),
      bottomSheet: MiniPlayerSheet(),
      body: SongPageView(song: song)
    );
  }
}


class SongPageView extends StatelessWidget {

  const SongPageView({super.key, required this.song});

  final Song song;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 300,
            child: song.imageWidget,
          ),
          Text(song.title, style: TextTheme.of(context).headlineSmall),
          Text(song.artist, style: TextTheme.of(context).labelMedium),

          Padding(padding: EdgeInsetsGeometry.directional(bottom: 20)),

          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 20,
              children: [
                QueueButton(song: song),
                PlayButton(song: song),
                FavoriteIcon(song: song)
              ],
            ),
          ),
          
          SongSlider(song: song),
        ],
      ),
    );
  }
}


class PlayButton extends StatelessWidget {

  const PlayButton({super.key, required this.song});

  final Song song;

  void _toggleSong(SongPlayer player) async {
    if (!player.isPlayingThis(song)) {
      player.playSong(song);
      return;
    }

    switch (player.playerState) {
      case PlayerState.playing: {
        await player.audioPlayer.pause();
        break;
      }

      case PlayerState.paused: {
        await player.audioPlayer.resume();
        break;
      }

      case PlayerState.completed: {
        await player.audioPlayer.seek(Duration.zero);
        player.audioPlayer.resume();
      }

      default:
       player.playSong(song);
    }
  }

  Widget _getButtonIcon(SongPlayer player) {
    if (!player.isPlayingThis(song)) {
      return Icon(Icons.arrow_right);
    }

    switch(player.playerState) {
      case PlayerState.completed: {
        return Icon(Icons.restart_alt);
      }

      case PlayerState.playing: {
        return Icon(Icons.pause);
      }

      default:
        return Icon(Icons.arrow_right);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SongPlayer>(
      builder: (context, songPlayer, child) =>  
          IconButton(
            onPressed: () => _toggleSong(songPlayer),
            icon: _getButtonIcon(songPlayer),
          )
      );
  }

}
