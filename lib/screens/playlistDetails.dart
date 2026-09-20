import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yamp/data/song.dart';
import 'package:yamp/screens/common/button/addToPlaylist.dart';
import 'package:yamp/screens/common/button/playQueue.dart';
import 'package:yamp/screens/common/orderableSongList.dart';
import 'package:yamp/screens/songList.dart';
import 'package:yamp/util/utils.dart';
import '../data/playlist.dart';

import 'common/common.dart';
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

  Widget _buildInteractions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PlayQueue(playlist: _playlist)
      ],
    );
  }

  Widget _buildHero(BuildContext context) {
    return Column(
      children: [
        Utils.buildLeadingPlaylistArt(context, _playlist, size: 200),
        Text(_playlist.name, style: TextTheme.of(context).displaySmall)
        //TextStyle(fontWeight: FontWeight.bold)
      ],
    );
  }

  Widget _buildSongList() {
    return Consumer<SongModel>(
      builder: (_, songModel, _) => 
          DefaultSongListView(
            songList: OrderableSongList(songs: _playlist.getSongList(songModel))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _playlist,
      builder: (_, _) {
        return SingleChildScrollView(
          child: Center(
          child: Padding(
            padding: const EdgeInsetsGeometry.only(top: 20),
            child: Column(
              spacing: 10,
              children: [
                _buildHero(context),
                _buildInteractions(),
                _buildSongList(),
                SongOpotionsDialog(playlist: _playlist)
              ] 
            ),
          )
        )
        );
      }
    );
  }
}

//              Text.rich(
//                TextSpan(
//                  text: 'Songs in ',
//                  style: Theme.of(context).textTheme.titleLarge,
//                  children: [
//                    TextSpan(
//                      text: _playlist.name,
//                      style: const TextStyle(
//                        fontWeight: FontWeight.bold,
//                      ),
//                    ),
//                  ],
//                ),
//              ),