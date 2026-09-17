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
    return ListView.builder(
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) => 
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: SongView(
              song: list[index], 
              interactionButtons: getInteractionButtons(list[index])
            ),
          )
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

  Widget _myBuild(BuildContext context) {
    return Row(
      spacing: 6,
      children: [
        _buildLeading(),
        _buildCenter(context),
        _buildTrailing(context),
      ],
    );
  }

  Widget _buildCenter(BuildContext context) {
    return Expanded(child: 
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(song.title, style: TextTheme.of(context).titleMedium),
          Text(song.artist, style: TextTheme.of(context).labelMedium),
          Text("Music", style: TextTheme.of(context).labelMedium)
          ]
        ),
    );
  }


  Widget _buildLeading() {
    return song.albumArt.displayImage();
  }


  Widget _buildTrailing(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          for (final button in interactionButtons) 
            button,
          Text(
            Utils.formatDuration(song.durationSeconds),
            style: TextTheme.of(context).labelLarge,
            ),
        ],
      ),
    );
  }


  @override  
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () => context.read<SongPlayer>().playSong(song),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: _myBuild(context),
        ),
      ),
    );
  }

}
