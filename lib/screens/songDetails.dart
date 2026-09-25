import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';
import 'package:yamp/screens/common/button/queueNext.dart';
import 'package:yamp/screens/common/glassWidget.dart';


import 'common/songSlider.dart';
import 'common/button/favoriteIcon.dart';
import 'common/button/queueButton.dart';
import 'common/button/editButton.dart';
import '../data/song.dart';
import 'common/button/playButton.dart';


class SongPage extends StatelessWidget {

  const SongPage({super.key, required this.song});

  final Song song;

  Widget _buildBackButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LiquidGlassButton(
        padding: EdgeInsetsGeometry.all(0),
        child: BackButton(color: Colors.black,),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: song, 
      builder: (context, child) => 
        Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent, 
            leading: _buildBackButton(),
          ),
          body: SongPageView(song: song)
      )
  );
  } 
}




class SongPageView extends StatelessWidget {

  SongPageView({super.key, required this.song});

  final Song song;

  late List<Widget> buttons = [
    QueueButton(song: song),
    EditButton(song: song),
    PlayButton(song: song),
    QueueNext(),
    FavoriteIcon(song: song),
  ];

  Widget _buildGlassText(String text, TextStyle style) {
    return AdaptiveGlass(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(text, style: style.copyWith(color: Colors.black, fontWeight: FontWeight.w500)),
      ),
    );
  }

  Widget _buildTextInfo(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        _buildGlassText(song.title, TextTheme.of(context).headlineSmall!),
        _buildGlassText(song.artist, TextTheme.of(context).labelMedium!),
      ],
    );
  }


  Widget _buildInteractionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 20,
      children: [
        for (final button in buttons)
          AdaptiveGlass(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
              child: button,
            )
          )
      ],
    );
  }

  Widget _buildSongSlider() {
    return Container(
      constraints: BoxConstraints(maxWidth: 600),
      child: AdaptiveGlass(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: SongSlider(song: song),
        )
      ),
    );
  }

  Widget _buildPageContents(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            song.albumArt.displayImage(size: 300),
            _buildTextInfo(context),
            _buildInteractionButtons(),
            _buildSongSlider()
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: song,
      builder: (_, _) => 
        Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Transform.scale(
                    scale: 1.1, 
                    child: song.albumArt.displayImage(),
                  ),
                ),
              ),
            ),
            _buildPageContents(context)
          ],
        )
    );
  }
}
