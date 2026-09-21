

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yamp/data/playlist.dart';
import 'package:yamp/data/song.dart';
import 'package:yamp/screens/common/orderableSongList.dart';

import '../../songList.dart';

class SongOpotionsDialog extends StatelessWidget {

  final Playlist playlist;

  const SongOpotionsDialog({super.key, required this.playlist});


  void _showSongOptionsDialog(BuildContext context) async {
    List<Song> songs = context.read<SongModel>().availableSongs;

    showDialog<Song>(
      context: context, 
      builder: (context) => Dialog(
        child: Container(
          constraints: BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: AddToPlaylistSongListView(songList: OrderableSongList(songs: songs), playlist: playlist),
            ) 
          )
        )
      )
    ); 
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
    playlist.addSong(song);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _addSongToPlaylist,
      icon: Icon(Icons.add)
    );
  }
  
}