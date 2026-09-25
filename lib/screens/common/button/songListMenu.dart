import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yamp/data/song.dart';
import 'package:yamp/screens/common/button/orderButton.dart';
import 'package:yamp/screens/common/button/playQueue.dart';
import 'package:yamp/data/orderableSongList.dart';

class SongListMenu extends StatelessWidget {

  final OrderableSongList _sortedSongList;

  const SongListMenu({super.key, required this._sortedSongList});


  @override
  Widget build(BuildContext context) {
    SongModel songModel = context.read<SongModel>();
    Queue<Song> queueSongs = 
        Queue.of(_sortedSongList.getSongs(songModel));

    return Row(
      spacing: 0,
      children: [
        OrderButton(songList: _sortedSongList),
        PlayQueue(queueSongs: queueSongs)
      ],
    );
  }


  
}