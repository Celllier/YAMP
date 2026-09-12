import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/song.dart';
import '../../../data/songPlayer.dart';



class QueueButton extends StatelessWidget {
  const QueueButton({super.key, required this.song});

  final Song song;

  @override
  Widget build(BuildContext context) {
    return Consumer<SongPlayer>(
      builder: (context, songPlayer, child) => ElevatedButton(
        onPressed: () => songPlayer.addToQueue(song), 
        child: Icon(Icons.queue)
      ),
    );
  } 
}