import 'package:sqflite/sqflite.dart';
import 'package:yamp/data/song.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/navigation.dart';

import 'data/songPlayer.dart';
import 'data/songRepository.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';


SongRepository songRepository = SongRepository();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  await songRepository.loadDatabase();
  await songRepository.populateWithUserSongs();

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<SongModel>(create: (context) => SongModel(songRepository: songRepository)),
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
