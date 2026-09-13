import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/song.dart';
import '../../data/songPlayer.dart';
import '../songDetails.dart';

import 'button/favoriteIcon.dart';

import 'glassWidget.dart';
import 'songSlider.dart';

class MiniPlayerSheet extends StatelessWidget {
  const MiniPlayerSheet({super.key});

  void _onTapNavigateToSongPage(BuildContext context, Song song) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SongPage(song: song))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SongPlayer>(
      builder: (context, songPlayer, child) {

        if (songPlayer.playingSong == null) {
          return const SizedBox.shrink();
        }

        Song song = songPlayer.playingSong!;

        return GestureDetector(
          onTap: () => _onTapNavigateToSongPage(context, song),
          child: _MiniPlayerWidget(songPlayer: songPlayer, song: song)
        );
      },
    );
  }
}


class _MiniPlayerWidget extends StatelessWidget {

  const _MiniPlayerWidget({super.key, required this.songPlayer, required this.song});

  final SongPlayer songPlayer;
  final Song song;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Transform.scale(
                scale: 1, 
                child: song.imageWidget,
              ),
            ),
          ),
        ),
    
        GlassWidget(
          blurSigma: 8,
          cornerRadius: 20,
          child: _MiniPlayerContents(songPlayer: songPlayer),
        ),
      ],
    );
  }
}


class _MiniPlayerContents extends StatelessWidget {

  const _MiniPlayerContents({super.key, required this._songPlayer});

  final SongPlayer _songPlayer;

  Widget _buildInteractionButtons(Song song) {
    return Row(
      mainAxisSize: MainAxisSize.min, 
      children: [
        PlayButton(
          song: song,
        ),

        FavoriteIcon(
          song: song, 
        )
      ],
    );
  }

  Widget _buildSongInformationWidget(BuildContext context, Song song) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 0,
        children: [
          Text(
            song.title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            song.artist,
            style: Theme.of(context).textTheme.labelMedium ,
          ),

          Padding(padding: EdgeInsetsGeometry.directional(bottom: 8)),
          SongSlider(song: song),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Song song = _songPlayer.playingSong!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 20,
        children: [

          SizedBox(
            height: 60,
            width: 60,
            child: song.imageWidget,
          ),
  
          _buildSongInformationWidget(context, song),
    
          _buildInteractionButtons(song),
        ],
      ),
    );
  }
}
