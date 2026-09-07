import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:yamp/data/songRepository.dart';
import 'song.dart';


class FavoriteModel extends ChangeNotifier {

  FavoriteModel({required this._songRepository}) {
    fetchFavorites(); 
  }

  final SongRepository _songRepository;
  List<Song> _favorites = []; 


  void toggleFavorite(Song song) {
    song.toggleFavorite();
    _songRepository.toggleFavoriteVal(song, song.isFavorited);
    _updateFavoritesList(song);
    notifyListeners();
  }


  void _updateFavoritesList(Song song) {
    if (_favorites.contains(song)) {
      _favorites.remove(song);
    } else {
      _favorites.add(song); 
    }

    print("songs in favorites");
    print(_favorites);
  }

  void fetchFavorites() async {
    _favorites = await _songRepository.fetchFavorites();
    notifyListeners();
  }

  
   List<Song> get favorites => _favorites;

}