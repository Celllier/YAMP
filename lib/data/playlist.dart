import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:yamp/data/songRepository.dart';

import 'song.dart';

class Playlist extends ChangeNotifier {

  final Queue<Song> _queue = Queue();

  final String _name = "Default playlist";

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

  Future<void> _loadDatabasePlaylists() async {

  }

  final List<Playlist> _loadedPlaylists = [
    Playlist(),
    Playlist(),
  ];

  List<Playlist> get playlists => _loadedPlaylists;
}

