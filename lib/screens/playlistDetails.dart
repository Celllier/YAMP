
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yamp/data/song.dart';
import 'package:yamp/screens/adaptiveLayout.dart';
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

  Widget _buildHero(BuildContext context, {double albumSize = 200}) {
    return Column(
      children: [
        Utils.buildLeadingPlaylistArt(context, _playlist, size: albumSize),
        Text(_playlist.name, style: TextTheme.of(context).displaySmall)
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



//TODO: make more modular
  Widget _buildSmallLayout(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 10,
      children: [
        _buildHero(context),
        _buildInteractions(),
        _buildSongList(),
        SongOpotionsDialog(playlist: _playlist)
      ] 
    );
  } 

  Widget _buildLargeLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 40,
      children: [
        SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: [
              _buildHero(context, albumSize: 300),
              _buildInteractions(),
              SongOpotionsDialog(playlist: _playlist),
            ],
          ),
        ),
        Expanded(
          child: _buildSongList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _playlist,
      builder: (_, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final isLargeScreen =
                constraints.maxWidth > AdaptiveLayout.largeScreenMinWidth;

            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 1600),
                  child: Padding(
                    padding: const EdgeInsetsGeometry.only(top: 20),
                    child: isLargeScreen
                        ? _buildLargeLayout(context)
                        : _buildSmallLayout(context),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
