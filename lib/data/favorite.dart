import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:yamp/data/songRepository.dart';
import 'song.dart';


class FavoriteModel extends ChangeNotifier {

  FavoriteModel({required this._songRepository}) {
    loadDatabaseFavorites();
  }

  final SongRepository _songRepository;
  //final SongModel songModel;

  List<Song> _favorites = []; 

  Set<int> favoriteIds = Set();


  // change param to id
  void toggleFavorite(Song song) {
    // should return if favoited o unfavorited
    song.toggleFavorite();
    _songRepository.toggleFavoriteVal(song, song.isFavorited);
    _updateFavoriteSet(song);
    notifyListeners();
  }

  void loadDatabaseFavorites() async {
    favoriteIds = await _songRepository.fetchFavoritesIds();
  }

  void _updateFavoriteSet(Song song) {
    int id = song.id!;
    if (favoriteIds.contains(id)) {
      favoriteIds.remove(id);
    } else {
      favoriteIds.add(id); 
    }
  }

  List<Song> fetchFavorites(SongModel songModel) {
    return songModel.availableSongs.where((song) => 
      favoriteIds.contains(song.id!)
    ).toList();
  }
  
}
