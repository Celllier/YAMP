import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/song.dart';
import '../data/songPlayer.dart';
import 'songDetails.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {

  MyAppBar({
    super.key, 
    this.title = 'Music Player',
    this.automaticallyImplyLeading = false
  });

  final String title;
  final bool automaticallyImplyLeading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(title),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

}





class MyBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SongPlayer>(
      builder: (context, songPlayer, child) {
        
        if (songPlayer.playingSong == null) {
          return const SizedBox.shrink();
        }

        //String albumImgPath = songPlayer.playingSong?.albumArtPath 
        //               ?? "assets/albums/arvores.jpg";

        String songTitle = songPlayer.playingSong?.title ?? "Not Playing";
        String artistName = songPlayer.playingSong?.artist ?? "Unknown";
        Song song = songPlayer.playingSong!;

        return Container(
          decoration: BoxDecoration(
            //color: Colors.,
            border: BoxBorder.all(width: 2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 60,
                child: song.imageWidget,
              ),

              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(songTitle, style: TextTheme.of(context).labelLarge),
                  Text(artistName, style: TextTheme.of(context).labelSmall),
                  SongSlider(song: songPlayer.playingSong!, width: 450, height: 50)
                ],
              ),

              PlayButton(song: songPlayer.playingSong!)
            ],
          ),
        );
      }
    );  
  }
}



class FavoriteIcon extends StatelessWidget {

  const FavoriteIcon({super.key, required this.song, required this.songModel});

  final Song song;
  final SongModel songModel;

  Widget _getFavoriteIcon() {
    return songModel.isInFavorites(song) 
    ? Icon(Icons.favorite) 
    : Icon(Icons.favorite_border);
  }

  void _toggleFavorite(BuildContext context) {
    String snackBarText;

    if (songModel.favorites.contains(song)) {
      songModel.removeFromFavorite(song);
      snackBarText = "Removed ${song.title} from Favorites";
    } else {
      songModel.addToFavorite(song);
      snackBarText = "Added ${song.title} to Favorites";
    }

    SnackBar snackBar = SnackBar(content: Text(snackBarText));

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _toggleFavorite(context), 
      child: _getFavoriteIcon()
    );
  }
}


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


//class SongAlbumArt extends StatelessWidget {
//
//  const SongAlbumArt({super.key, required this.songImage});
//
//  final SongImage songImage;
//
//  @override
//  Widget build(BuildContext context) {
//    return AspectRatio(
//      aspectRatio: 1,
//      child: Container(
//        decoration: BoxDecoration(
//          image: DecorationImage(
//            
//            )
//        ),
//      ),
//    );
//    
//  }
//}