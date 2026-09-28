

import 'dart:collection';
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



  void clear() {
    _history.clear();
    _next.clear();
  }

  bool get canQueueNext => _next.isNotEmpty;
  Queue<Song> get nextSongs => _next;
  List<Song> get nextSongList => _next.toList();
  Song? get currentSong => _currentPlaying;
}