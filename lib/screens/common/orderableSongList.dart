
import 'package:flutter/material.dart';
import 'package:yamp/data/order/order.dart';
import 'package:yamp/data/song.dart';

class OrderableSongList extends ChangeNotifier {
  List<int> ids;

  OrderableSongList({required List<int> ids}) 
      : ids = List.of(ids);

  void sort(OrderStrategy orderStrategy, SongModel model) {
    final songs = {
    for (final song in model.fetchSongs(ids))
      song.id: song,
    };

    ids.sort(
      (a, b) => orderStrategy.compare(
        songs[a]!,
        songs[b]!,
      ),
    );
    notifyListeners();
  }

  void setIds(List<int> ids) {
    this.ids = List.of(ids);
  }

  List<Song> getSongs(SongModel model) {
    return model.fetchSongs(ids);
  }

  int get length => ids.length;
}