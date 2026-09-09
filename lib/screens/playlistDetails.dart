

import 'package:flutter/material.dart';
import '../data/playlist.dart';

import 'common.dart';

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
      body: PlaylistDetailsView(playlist: _playlist)
      
    );
  }
  
}

class PlaylistDetailsView extends StatelessWidget {
  
  const PlaylistDetailsView({super.key, required this._playlist});

  final Playlist _playlist;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          
        ] 
      )
    );
  }
}