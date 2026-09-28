import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';

import 'package:audioplayers/audioplayers.dart';

import 'songQueue.dart';
import '../data/song.dart';

class SongPlayer extends ChangeNotifier {

  final AudioPlayer _audioPlayer = AudioPlayer();
  PlayerState _playerState = PlayerState.stopped;

  final SongQueue songQueue = SongQueue();
  late SongMetaData metaData;

  SongPlayer() {
    _audioPlayer.setReleaseMode(ReleaseMode.stop);
    _audioPlayer.onPlayerStateChanged.listen((PlayerState s) {
      _playerState = s;
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((data) {
      queueNextSong();
    });

    metaData = SongMetaData(
      audioPlayer: _audioPlayer, 
      notifyCallback: notifyListeners
    );
  }


  void playSong(Song song) {
    metaData.restart();
    songQueue.playSong(song);
    _audioPlayer.play(DeviceFileSource(song.sourcePath));

    notifyListeners();
  }

  void playQueue(Queue<Song> songs) {
    playSong(songs.first);

    songQueue.clear();
    songQueue.addAll(songs.skip(1));

    notifyListeners();
  }

  Song? queueNextSong() {
    Song? next = songQueue.queueNextSong();
    if (next != null) {
      playSong(next);
    }
    return next;
  }


  bool isPlayingThis(Song song) {
    return song.sourcePath == playingSong?.sourcePath;
  } 


  void seekSong(double value) {
    _audioPlayer.seek(
    Duration(milliseconds: value.toInt()));
  }

  void addToQueue(Song song) {
    songQueue.addToQueue(song);
    notifyListeners();
  }

  List<int> getListId() {
    final List<int> songs = [];
    for (final Song song in songQueue.nextSongs) {
      songs.add(song.id!);
    }
    return songs;
  }

  @override
  void dispose() {
    metaData.dispose();
    super.dispose();
  }


  Song? get playingSong => songQueue.currentSong;
  PlayerState get playerState => _playerState;
  List<Song> get songQueueList => songQueue.nextSongList;
  SongMetaData? get songMetaData => metaData;
  AudioPlayer get audioPlayer => _audioPlayer;

  bool get canQueueNext => songQueue.canQueueNext;

  double get duration => metaData.durationInMilli;
  double get position => metaData.positionInMilli;
}



//change to song statistics
class SongMetaData {

  SongMetaData({required this._audioPlayer, required this._notifyCallback}) {
    _durationSubscription = _audioPlayer.onDurationChanged.listen((Duration duration)  {
      _duration = duration;
      _notifyCallback();
    });

    _positionSubscription = _audioPlayer.onPositionChanged.listen((Duration postion) {
      _position = postion;
      _notifyCallback();
    });
  }

  final AudioPlayer _audioPlayer;

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  final void Function() _notifyCallback;

  StreamSubscription<Duration>? _durationSubscription;
  StreamSubscription<Duration>? _positionSubscription;


  Duration get duration => _duration;
  Duration get position => _position;
  double get durationInMilli => _duration.inMilliseconds.toDouble();
  double get positionInMilli => _position.inMilliseconds.toDouble();

  void restart() {
    _duration = Duration.zero;
    _position = Duration.zero;
  }


  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _duration = Duration.zero;
    _position = Duration.zero;
  }

}