import 'dart:ui';

import 'package:yamp/data/song.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/favorite.dart';
import 'data/songPlayer.dart';
import 'data/songRepository.dart';
import 'data/playlist.dart';
import 'screens/adaptiveLayout.dart';
import 'data/databaseBuilder.dart';


DatabaseBuilder databaseBuilder = DatabaseBuilder();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await databaseBuilder.init();
  SongRepository songRepository = 
        SongRepository(database: databaseBuilder.database);

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<SongModel>(create: (context) => SongModel(songRepository: songRepository)),
          ChangeNotifierProvider<FavoriteModel>(create: (context) => FavoriteModel(songRepository: songRepository)),
          ChangeNotifierProvider<PlaylistModel>(create: (context) => PlaylistModel(songRepository: songRepository)),
          ChangeNotifierProvider<SongPlayer>(create: (context) => SongPlayer()),
        ],
        child: const MainApp(),
      )
    );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  
  ThemeData _getTheme() {
    return ThemeData(
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          iconColor: WidgetStateColor.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return const Color.fromARGB(255, 75, 75, 75);
            } else {
              return Colors.black;
            }
          })  
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AdaptiveLayout(),
      theme: _getTheme(),
    );
  }
}
