

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yamp/data/playlist.dart';
import 'package:yamp/data/song.dart';
import 'package:yamp/data/songPlayer.dart';

class PlayQueue extends StatelessWidget {

  final Playlist playlist;

  const PlayQueue({super.key, required this.playlist});

  void _playPlaylist(BuildContext context){
    playlist.play(
      context.read<SongModel>(), 
      context.read<SongPlayer>()
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _playPlaylist(context), 
      icon: Icon(Icons.play_arrow,)
    );
  }

  
}