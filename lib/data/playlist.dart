import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:yamp/data/songRepository.dart';

import 'song.dart';

class Playlist extends ChangeNotifier {

  Playlist({
    required this._name,
    required this._songRepository,
    this._id
  }) {
    _loadPlaylistSongs();
  }

  Queue<int> _queueIds = Queue();
  final String _name;
  final SongRepository _songRepository;
  int? _id;


  //void add(Song song) {
  //  _queue.add(song);
  //  //_songRepository
  //  notifyListeners();
  //} 
//
  //void remove(Song song) {
  //  _queue.remove(song);
  //  //_songRepository
  //  notifyListeners();
  //}

  Future<void> _loadPlaylistSongs() async {
    _queueIds = await _songRepository.loadPlaylistSongs(playlistId: _id!);
    notifyListeners();
  }

  List<Song> getSongList(SongModel songModel) {
    return songModel.availableSongs.where((song) =>
      _queueIds.contains(song.id!)
    ).toList();
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

