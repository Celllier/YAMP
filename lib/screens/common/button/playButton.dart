

// put in another file
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/songPlayer.dart';
import '../../../data/song.dart';

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
