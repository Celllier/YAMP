

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yamp/data/playlist.dart';
import 'package:yamp/data/song.dart';

import '../../songList.dart';

class SongOpotionsDialog extends StatelessWidget {

  final Playlist playlist;

  const SongOpotionsDialog({super.key, required this.playlist});


  void _showSongOptionsDialog(BuildContext context) async {
    List<Song> songs = context.read<SongModel>().availableSongs;

    Song? song = await showDialog<Song>(
      context: context, 
      builder: (context) => Dialog(
        child: Container(
          constraints: BoxConstraints(maxWidth: 400),
          child: AddToPlaylistSongListView(list: songs, playlist: playlist)
        )
      )
    ); 

    if (song != null) {

    } 
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _showSongOptionsDialog(context),
      icon: Icon(Icons.add),
    );
  }

}

class AddToPlaylistButton extends StatelessWidget {

  final Playlist playlist;
  final Song song;

  const AddToPlaylistButton({super.key, required this.playlist, required this.song});

  void _addSongToPlaylist() {
    
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _addSongToPlaylist,
      icon: Icon(Icons.add)
    );
  }
  
}