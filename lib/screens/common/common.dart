import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/song.dart';
import '../../data/favorite.dart';
import '../../data/songPlayer.dart';

import 'package:liquid_glass_easy/liquid_glass_easy.dart';


class MyAppBar extends StatelessWidget implements PreferredSizeWidget {

  MyAppBar({
    super.key, 
    this.title = 'YetAnotherMusicPlayer',
    this.automaticallyImplyLeading = false
  });

  final String title;
  final bool automaticallyImplyLeading;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: LiquidGlassLens(
        style: LiquidGlassStyle(
          shape: LiquidGlassShape.continuousRoundedRectangle(cornerRadius: 0), 
          appearance: LiquidGlassAppearance(
            color: const Color(0x4DFFFFFF), 
            blur: const LiquidGlassBlur(sigmaX: 18, sigmaY: 18),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.black.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
          ),
          child: AppBar(
            title: Text(title),
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: automaticallyImplyLeading,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

}








class FavoriteIcon extends StatelessWidget {

  const FavoriteIcon({super.key, required this.song, required this.favoriteModel});

  final Song song;
  final FavoriteModel favoriteModel;
  //TODO: function call back onFavorited for abstracted snackbar

  Widget _getFavoriteIcon() {
    return song.isFavorited 
    ? Icon(Icons.favorite) 
    : Icon(Icons.favorite_border);
  }

  void _toggleFavorite(BuildContext context) {
    String snackBarText;

    if (song.isFavorited) {
      snackBarText = "Removed ${song.title} from Favorites";
    } else {
      snackBarText = "Added ${song.title} to Favorites";
    }

    favoriteModel.toggleFavorite(song);

    SnackBar snackBar = SnackBar(content: Text(snackBarText));

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _toggleFavorite(context), 
      icon: _getFavoriteIcon(),
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
