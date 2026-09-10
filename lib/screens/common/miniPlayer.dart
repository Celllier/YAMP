
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/song.dart';
import '../../data/songPlayer.dart';
import '../songDetails.dart';

import 'package:liquid_glass_easy/liquid_glass_easy.dart';

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
            LiquidGlassLens(
                style: LiquidGlassStyle(
                  shape: LiquidGlassShape.continuousRoundedRectangle(
                    cornerRadius: 20,
                    borderWidth: 1,
                  ),
                  appearance: LiquidGlassAppearance(
                    color: const Color.fromARGB(136, 255, 255, 255),
                    blur: const LiquidGlassBlur(
                      sigmaX: 6,
                      sigmaY: 6,
                    ),
                  ),
                ),
                child: MiniPlayerContents(songPlayer: songPlayer)
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
  
          Column(
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
                width: 450,
                height: 30,
              ),
            ],
          ),
  
          const SizedBox(width: 10),
  
          PlayButton(
            song: song,
          ),
        ],
      ),
    );
  }
}
