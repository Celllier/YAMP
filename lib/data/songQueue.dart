

import 'dart:collection';
import 'package:yamp/util/utils.dart';

import 'song.dart';

class SongQueue {

  final Queue<Song> _history = Queue();
  final Queue<Song> _next = Queue();
  Song? _currentPlaying;

  Song? queueNextSong() {
     if (_next.isNotEmpty) {
      _history.add(_currentPlaying!);
      _currentPlaying = _next.removeFirst();
      return _currentPlaying;
    } 

    return null;
  }

  void playSong(Song song) {
    _currentPlaying = song;
  }


  void addToQueue(Song song) {
    _next.add(song);
  }

  void addAll(Iterable<Song> iterable) {
    _next.addAll(iterable);
  }



  List<int> getNextId() {
    return Utils.getIterableSongId(_next);
  }

  List<int> getHistoryId() {
    return Utils.getIterableSongId(_history);
  }



  void clear() {
    _history.clear();
    _next.clear();
  }

  bool get canQueueNext => _next.isNotEmpty;
  Queue<Song> get nextSongs => _next;
  Queue<Song> get historySongs => _next;
  List<Song> get nextSongList => _next.toList();
  Song? get currentSong => _currentPlaying;
}