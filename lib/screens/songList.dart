import 'package:yamp/data/playlist.dart';
import 'package:yamp/data/song.dart';
import 'package:flutter/material.dart';
import 'package:yamp/data/songPlayer.dart';
import 'package:yamp/screens/common/button/addToPlaylist.dart';

import 'common/button/favoriteIcon.dart';
import 'common/button/queueButton.dart';

import 'package:provider/provider.dart';
import '../util/utils.dart';

abstract class SongListView extends StatelessWidget {

  const SongListView({super.key, required this.list});

  final List<Song> list;
  List<Widget> getInteractionButtons(Song song);

  @override
  Widget build(BuildContext context) {
    return ListView(
        shrinkWrap: true,
        children: [
          for (Song song in list) 
            SongView(
              song: song, 
              interactionButtons: getInteractionButtons(song)
            ),
        ],
      );
  }
}

class DefaultSongListView extends SongListView {
  const DefaultSongListView({super.key, required super.list});

  @override
  List<Widget> getInteractionButtons(Song song) {
    return [
      QueueButton(song: song),
      FavoriteIcon(song: song),
    ];
  }
}

class AddToPlaylistSongListView extends SongListView {

  final Playlist playlist;
  const AddToPlaylistSongListView({super.key, required super.list, required this.playlist});

  @override
  List<Widget> getInteractionButtons(Song song) {
    return [
      AddToPlaylistButton(playlist: playlist, song: song)
    ];
  }
}



class SongView extends StatelessWidget {
  const SongView({super.key, required this.song, required this.interactionButtons});

  final Song song;
  final List<Widget> interactionButtons;


  Widget _buildLeading() {
    return Container(
      width: 100,
      height: 100,
      child: song.imageWidget
    );
  }


  Widget _buildTrailing() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 10,
      children: [
        for (final button in interactionButtons) 
          button,
        Text(Utils.formatDuration(song.durationSeconds)),
      ],
    );
  }


  @override  
  Widget build(BuildContext context) {
    return ListTile(
      trailing: _buildTrailing(),
      leading: _buildLeading(),
      title: Text(song.title),
      subtitle: Text(song.artist),
      onTap: () => context.read<SongPlayer>().playSong(song)
    );
  }

}
