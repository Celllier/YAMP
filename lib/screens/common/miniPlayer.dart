import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yamp/data/favorite.dart';
import 'package:yamp/screens/common/common.dart';

import '../../data/song.dart';
import '../../data/songPlayer.dart';
import '../songDetails.dart';

import 'glassWidget.dart';

class MiniPlayerSheet extends StatelessWidget {
  const MiniPlayerSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SongPlayer>(
      builder: (context, songPlayer, child) {
        if (songPlayer.playingSong == null) {
          return const SizedBox.shrink();
        }

        Song song = songPlayer.playingSong!;

        return Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Transform.scale(
                    scale: 1, // avoid edge artifacts from the blur
                    child: song.imageWidget,
                  ),
                ),
              ),
            ),

            GlassWidget(
              blurSigma: 8,
              cornerRadius: 20,
              child: MiniPlayerContents(songPlayer: songPlayer),
            ),
          ],
        );
      },
    );
  }
}


class MiniPlayerContents extends StatelessWidget {

  const MiniPlayerContents({super.key, required this._songPlayer});

  final SongPlayer _songPlayer;

  //TODO: make this better
  @override
  Widget build(BuildContext context) {
    Song song = _songPlayer.playingSong!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 60,
            width: 60,
            child: song.imageWidget,
          ),
  
          const SizedBox(width: 10),
  
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.title,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Text(
                  song.artist,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                SongSlider(
                  song: song,
                ),
              ],
            ),
          ),
  
          const SizedBox(width: 10),
  
          PlayButton(
            song: song,
          ),

          Consumer<FavoriteModel>(
            builder: (context, favoriteModel, child) => 
              FavoriteIcon(
                song: song, 
                favoriteModel: favoriteModel
              )
          ),

        ],
      ),
    );
  }
}
