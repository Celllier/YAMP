import 'package:yamp/data/song.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/navigation.dart';

import 'data/songPlayer.dart';

void main() {
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<SongModel>(create: (context) => SongModel()),
          ChangeNotifierProvider<SongPlayer>(create: (context) => SongPlayer()),
        ],
        child: const MainApp(),
      )
    );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyNavigationBar()
    );
  }
}


// fix song duration problem