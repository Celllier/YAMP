
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yamp/screens/navigation.dart';
import 'common.dart';

import '../data/song.dart';
import '../data/playlist.dart';

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
      
          Consumer<PlaylistModel>(
            builder: (context, playlistModel, child) => ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                for (final playlist in playlistModel.playlists) 
                  _buildPlayListTile(playlist)
              ],
            ),
          ),
      
          FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context, 
                isDismissible: true,
                showDragHandle: true,
                builder: (context) => 
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Create a Playlist',
                          style: TextTheme.of(context).titleLarge,
                        ),
                        TextField(
                          autofocus: true,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            labelText: 'Name your playlist',
                            hintText: 'My Playlist', 
                          ),
                        )
                      ],
                    ),
                  )
              );
            },
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





