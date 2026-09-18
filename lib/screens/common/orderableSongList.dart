
import 'package:flutter/material.dart';
import 'package:yamp/data/order/order.dart';
import 'package:yamp/data/song.dart';

class OrderableSongList extends ChangeNotifier {
  final List<Song> songs;

  OrderableSongList({required this.songs});

  void sort(OrderStrategy orderStrategy) {
    orderStrategy.order(songs);
    notifyListeners();
  }

  int get length => songs.length;
  List<Song> get list => songs;
}