import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yamp/data/song.dart';
import 'package:yamp/screens/songList.dart';
import '../data/playlist.dart';

import 'common.dart';
import 'common/miniPlayer.dart';

class PlaylistDetailsPage extends StatelessWidget {

  const PlaylistDetailsPage({super.key, required this._playlist});

  final Playlist _playlist;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: _playlist.name,
        automaticallyImplyLeading: true,
      ),
      bottomSheet: MiniPlayerSheet(),
      body: PlaylistDetailsView(playlist: _playlist)
      
    );
  }
  
}

class PlaylistDetailsView extends StatelessWidget {
  
  const PlaylistDetailsView({super.key, required this._playlist});

  final Playlist _playlist;


  void _addSongToPlaylist() {
    int songId = 1;
    //_playlist.add(song)
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text.rich(
            TextSpan(
              text: 'Songs in ',
              style: Theme.of(context).textTheme.titleLarge,
              children: [
                TextSpan(
                  text: _playlist.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Consumer<SongModel>(
            builder: (context, songModel, child) => 
              SongListView(list: _playlist.getSongList(songModel)),
          ),

          FloatingActionButton(
            onPressed: _addSongToPlaylist,
            child: Icon(Icons.add),
          )
        ] 
      )
    );
  }
}