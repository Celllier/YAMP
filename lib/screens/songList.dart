import 'package:favorites/data/song.dart';
import 'package:flutter/material.dart';

import 'songDetails.dart';
import 'common.dart';

class SongListView extends StatelessWidget {

  const SongListView({super.key, required this.list, required this.songModel});

  final List<Song> list;
  final SongModel songModel;
  

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children: [
          for (Song song in list) 
            SongView(song: song, songModel: songModel),
        ],
      ),
    );
  }
}



class SongView extends StatelessWidget {
  const SongView({super.key, required this.song, required this.songModel});

  final Song song;
  final SongModel songModel;

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


  Widget _buildTrailing(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 10,
      children: [
        FavoriteIcon(song: song, songModel: songModel),
        
        Text(_formatDuration(song.durationSeconds)),
      ],
    );
  }


  @override  
  Widget build(BuildContext context) {
    return ListTile(
      trailing: _buildTrailing(context),
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