import 'package:yamp/data/song.dart';
import 'package:yamp/data/songPlayer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'common.dart';
import 'songList.dart';
import 'playlist.dart';


class MyNavigationBar extends StatefulWidget {
  const MyNavigationBar({super.key});

  @override
  State<MyNavigationBar> createState() => _MyNavigationBarState();
}


class _MyNavigationBarState extends State<MyNavigationBar> {

  int _selectedPageIndex = 0;

  final PageController _pageController = PageController();

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedPageIndex = index;
    });

    _pageController.animateToPage(
      _selectedPageIndex, 
      duration: Duration(milliseconds: 200),
      curve: Curves.easeIn
    );
  } 


  void _onPageChanged(int index) {
    setState(() {
      _selectedPageIndex = index;
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      bottomSheet: MyBottomSheet(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedPageIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: [
          NavigationDestination(icon: Icon(Icons.music_note), label: 'Songs'),
          NavigationDestination(icon: Icon(Icons.playlist_play), label: 'Playlists'),
          NavigationDestination(icon: Icon(Icons.queue_music), label: "Queue"),
          NavigationDestination(icon: Icon(Icons.favorite), label: 'Favorites'),
        ],
      ),

      body: Consumer2<SongModel, SongPlayer>(
        builder: (context, songModel, songPlayer, child) =>PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: [
              SongListView(list: songModel.availableSongs, songModel: songModel),
              PlaylistListingPage(songModel: songModel),
              SongListView(list: songPlayer.songQueueList, songModel: songModel),
              SongListView(list: songModel.favorites, songModel: songModel),
            ],
          ),
      )
    );

  }
}



