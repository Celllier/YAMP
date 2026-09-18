import 'package:flutter/material.dart';
import 'package:yamp/screens/common/button/queueNext.dart';


import 'common/common.dart';
import 'common/songSlider.dart';
import 'common/button/favoriteIcon.dart';
import 'common/button/queueButton.dart';
import 'common/button/editButton.dart';
import '../data/song.dart';
import 'common/button/playButton.dart';


class SongPage extends StatelessWidget {

  const SongPage({super.key, required this.song});

  final Song song;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: song, 
      builder: (context, child) => Scaffold(
        appBar: MyAppBar(title: song.title, automaticallyImplyLeading: true),
        body: SongPageView(song: song)
    )
  );
  } 
}


class SongPageView extends StatelessWidget {

  const SongPageView({super.key, required this.song});

  final Song song;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: song,
      builder: (_, _) => 
        Center(
        child: Column(
          children: [
            
            song.albumArt.displayImage(size: 300),
            
            Text(song.title, style: TextTheme.of(context).headlineSmall),
            Text(song.artist, style: TextTheme.of(context).labelMedium),
      
            Padding(padding: EdgeInsetsGeometry.directional(bottom: 20)),
      
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 20,
                children: [
                  QueueButton(song: song),
                  PlayButton(song: song),
                  QueueNext(),
                  FavoriteIcon(song: song),
                  EditButton(song: song),
                ],
              ),
            ),
            
            
            Container(
              constraints: BoxConstraints(maxWidth: 600),
              child: SongSlider(song: song)
            ),
          ],
        ),
      ),
    );
  }
}


