
import 'package:flutter/material.dart';
import 'package:yamp/screens/navigation.dart';
import 'common.dart';

import '../data/song.dart';

class PlaylistListingPage extends StatelessWidget {

  const PlaylistListingPage({super.key, required this.songModel});

  final SongModel songModel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            "Your Playlists",
            style: TextTheme.of(context).headlineMedium,
          ),
      
          ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [
              for (final playlist in songModel.playlists) 
                _buildPlayListTile(playlist)
            ],
          ),
      
          FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.add),
          )
        ],
      ),
    );
  }



  Widget _buildPlayListTile(Playlist playlist) {
    return ListTile(
      leading: Text(playlist.name),
    );
  }
}





