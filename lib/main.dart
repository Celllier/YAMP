import 'package:yamp/data/song.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/navigation.dart';

import 'data/favorite.dart';
import 'data/songPlayer.dart';
import 'data/songRepository.dart';


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
