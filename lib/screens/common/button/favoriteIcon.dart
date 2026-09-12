import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/song.dart';
import '../../../data/favorite.dart';



class FavoriteIcon extends StatelessWidget {

  const FavoriteIcon({super.key, required this.song});

  final Song song;
  //final FavoriteModel favoriteModel;
  //TODO: function call back onFavorited for abstracted snackbar

  Widget _getFavoriteIcon() {
    return song.isFavorited 
    ? Icon(Icons.favorite) 
    : Icon(Icons.favorite_border);
  }

  void _toggleFavorite(BuildContext context, FavoriteModel favoriteModel) {
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
    return Consumer<FavoriteModel>(
      builder: (context, favoriteModel, child) =>  
        IconButton(
          onPressed: () => _toggleFavorite(context, favoriteModel), 
          icon: _getFavoriteIcon(),
        )
      );
  }
}