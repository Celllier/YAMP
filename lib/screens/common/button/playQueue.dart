import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yamp/data/song.dart';
import 'package:yamp/data/songPlayer.dart';

class PlayQueue extends StatelessWidget {

  final Queue<Song> queueSongs;

  const PlayQueue({super.key, required this.queueSongs});

  void _playQueue(BuildContext context){
    SongPlayer songPlayer = context.read<SongPlayer>();
    songPlayer.playQueue(queueSongs);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _playQueue(context), 
      icon: Icon(Icons.play_arrow,)
    );
  }

  
}