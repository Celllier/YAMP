import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:yamp/data/songPlayer.dart';
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


  void addSong(Song song) {
    _queueIds.add(song.id!);
    _songRepository.addSongToPlaylist(id, song.id!, nextQueuePosition);
    notifyListeners();
  } 
//
  //void remove(Song song) {
  //  _queue.remove(song);
  //  //_songRepository
  //  notifyListeners();
  //}

  void play(SongModel songModel, SongPlayer songPlayer){
    songPlayer.playQueue(getSongs(songModel));
  }

  Future<void> _loadPlaylistSongs() async {
    _queueIds = await _songRepository.loadPlaylistSongs(playlistId: _id!);
    notifyListeners();
  }

  Queue<Song> getSongs(SongModel songModel) {
    return Queue.from(getSongList(songModel));
  }

  List<Song> getSongList(SongModel songModel) {
    return songModel.availableSongs.where((song) =>
      _queueIds.contains(song.id!)
    ).toList();
  }

  String get name => _name;
  int get id => _id!;
  int get nextQueuePosition => _queueIds.length + 1;
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

