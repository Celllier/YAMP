import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yamp/data/song.dart';
import 'package:yamp/data/songPlayer.dart';
import 'package:yamp/screens/songDetails.dart';

class QueueNext extends StatelessWidget {

  const QueueNext({super.key});

  void _onPressed(BuildContext context, SongPlayer songPlayer){
    Song? song = songPlayer.queueNextSong();

    if (song != null) {
      Navigator.pop(context);
      Navigator.push(
        context, 
        MaterialPageRoute(builder: (context) => 
          SongPage(song: song))
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    SongPlayer songPlayer = context.read<SongPlayer>();

    return IconButton(
      onPressed: songPlayer.canQueueNext 
        ? () => _onPressed(context, songPlayer) 
        : null,  
      icon: Icon(Icons.skip_next)
    );
  }

  
}