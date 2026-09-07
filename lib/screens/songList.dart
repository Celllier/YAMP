import 'package:yamp/data/song.dart';
import 'package:flutter/material.dart';

import '../data/favorite.dart';
import 'songDetails.dart';
import 'common.dart';

import 'package:provider/provider.dart';

class SongListView extends StatelessWidget {

  const SongListView({super.key, required this.list});

  final List<Song> list;
  

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children: [
          for (Song song in list) 
            SongView(song: song),
        ],
      ),
    );
  }
}



class SongView extends StatelessWidget {
  const SongView({super.key, required this.song});

  final Song song;

  String _formatDuration(int seconds) {
    String min = "${(song.durationSeconds / 60).floor()}";
    int isec = song.durationSeconds % 60;
    String sec = isec < 10 ? "0$isec" : "$isec";

    return "$min:$sec";
  }


  Widget _buildLeading() {
    return Container(
      width: 100,
      height: 100,
      child: song.imageWidget
    );
  }


  Widget _buildTrailing() {
    return Consumer<FavoriteModel>(
      builder: (context, favoriteModel, child) => 
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            FavoriteIcon(song: song, favoriteModel: favoriteModel),
            Text(_formatDuration(song.durationSeconds)),
          ],
        ) 
    );
  }


  @override  
  Widget build(BuildContext context) {
    return ListTile(
      trailing: _buildTrailing(),
      leading: _buildLeading(),
      title: Text(song.title),
      subtitle: Text(song.artist),
      onTap: () => Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context) => SongPage(song: song),
          )
        )
    );
  }

}
