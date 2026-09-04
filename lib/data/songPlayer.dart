import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';

import 'package:audioplayers/audioplayers.dart';

import '../data/song.dart';

class SongPlayer extends ChangeNotifier {

  SongPlayer() {
    _audioPlayer.setReleaseMode(ReleaseMode.stop);
    _audioPlayer.onPlayerStateChanged.listen((PlayerState s) {
      _playerState = s;
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((data) {
      queueNextSong();
    });
  }

  
  final AudioPlayer _audioPlayer = AudioPlayer();
  PlayerState _playerState = PlayerState.stopped;

  final Queue<Song> _songQueue = Queue();
  QueuedSong? _playingSong;


  void playSong(Song song) {
    removePreviousSong();

    SongMetaData metaData = SongMetaData(
      audioPlayer: _audioPlayer, 
      notifyCallback: notifyListeners
    );

    _playingSong = (song: song, metaData: metaData);
    _audioPlayer.play(DeviceFileSource(song.sourcePath));

    notifyListeners();
  }

  void queueNextSong() {
     if (songQueue.isNotEmpty) {
      playSong(songQueue.removeFirst());
    } else {
      print("No songs to queue");
    }
  }


  bool isPlayingThis(Song song) {
    return song.sourcePath == _playingSong?.song.sourcePath;
  } 


  void seekSong(double value) {
    _audioPlayer.seek(
    Duration(milliseconds: value.toInt()));
  }

  //todo: Implement Song Queueing system
  void addToQueue(Song song) {
    _songQueue.add(song);
    notifyListeners();
  }


  void removePreviousSong() {
    _playingSong?.metaData.dispose();
    _playingSong = null;
  }

  @override
  void dispose() {
    removePreviousSong();
    super.dispose();
  }


  Song? get playingSong => _playingSong?.song;
  PlayerState get playerState => _playerState;
  Queue<Song> get songQueue => _songQueue;
  List<Song> get songQueueList => _songQueue.toList();
  SongMetaData? get songMetaData => _playingSong?.metaData;
  AudioPlayer get audioPlayer => _audioPlayer;

  double get duration => _playingSong?.metaData.durationInMilli ?? 0;
  double get position => _playingSong?.metaData.positionInMilli ?? 0;
}


typedef QueuedSong = ({Song song, SongMetaData metaData});


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


  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _duration = Duration.zero;
    _position = Duration.zero;
  }

}