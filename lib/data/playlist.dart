import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:yamp/data/songRepository.dart';

import 'song.dart';

class Playlist extends ChangeNotifier {

  Playlist({
    required this._name,
    this._id
  });

  final Queue<Song> _queue = Queue();
  final String _name;
  int? _id;


  void add(Song song) {
    _queue.add(song);
    notifyListeners();
  } 

  void remove(Song song) {
    _queue.remove(song);
    notifyListeners();
  }

  String get name => _name;
}



class PlaylistModel extends ChangeNotifier {

  PlaylistModel({required this._songRepository}) {
    _loadDatabasePlaylists();
  }

  final SongRepository _songRepository;
  List<Playlist> _loadedPlaylists = [];

  Future<void> _loadDatabasePlaylists() async {
    _loadedPlaylists = await _songRepository.loadPlaylists();
    notifyListeners();
  }


  void createPlaylist(String name) async {
    Playlist playlist = await _songRepository.createPlaylist(name);
    _loadedPlaylists.add(playlist);
    notifyListeners();
  }

  List<Playlist> get playlists => _loadedPlaylists;
}

