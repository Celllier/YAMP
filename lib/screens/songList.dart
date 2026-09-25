import 'package:yamp/data/playlist.dart';
import 'package:yamp/data/song.dart';
import 'package:flutter/material.dart';
import 'package:yamp/data/songPlayer.dart';
import 'package:yamp/screens/common/button/addToPlaylist.dart';
import 'package:yamp/screens/common/button/songListMenu.dart';
import 'package:yamp/data/orderableSongList.dart';

import 'package:flutter/foundation.dart';
import 'common/button/favoriteIcon.dart';
import 'common/button/queueButton.dart';

import 'package:provider/provider.dart';
import '../util/utils.dart';


abstract class SongListView extends StatefulWidget {
  
  final List<int> songList;
  final bool isOrderable;
  List<Widget> getInteractionButtons(Song song);

  const SongListView({super.key, required this.songList, this.isOrderable = true});

  @override
  State<SongListView> createState() => _SongListViewState(songIds: songList);
}


class _SongListViewState extends State<SongListView> {

  final OrderableSongList _sortedSongList;

  _SongListViewState({required List<int> songIds}) 
      : _sortedSongList = OrderableSongList(ids: songIds);


  @override  //asynchronous song loading initializes _sortedSongList empty
  void didUpdateWidget(covariant SongListView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!listEquals(oldWidget.songList, widget.songList)) {
      _sortedSongList.setIds(widget.songList);
    }
  }


  Widget _buildList(BuildContext context) {
    List<Song> songs = _sortedSongList.getSongs(context.read<SongModel>());
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: songs.length,
      itemBuilder: (_, index) => 
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: SongView(
            song: songs[index], 
            interactionButtons: widget.getInteractionButtons(songs[index])
          ),
        )
    );
  }


  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _sortedSongList, 
      builder: (_, _) => 
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.isOrderable)
              SongListMenu(sortedSongList: _sortedSongList),
    
            _buildList(context)
          ],
        )
    );
  }
}


class DefaultSongListView extends SongListView {
  const DefaultSongListView({super.key, required super.songList, super.isOrderable});

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
  const AddToPlaylistSongListView({super.key, required super.songList, required this.playlist, super.isOrderable});

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
