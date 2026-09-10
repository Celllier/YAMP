import 'package:yamp/data/song.dart';
import 'package:yamp/data/songPlayer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/favorite.dart';
import 'common/common.dart';
import 'common/miniPlayer.dart';
import 'songList.dart';
import 'playlist.dart';

import 'package:liquid_glass_easy/liquid_glass_easy.dart';


//TODO: change name
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
      duration: Duration(milliseconds: 350),
      curve: Curves.easeOutQuint
    );
  } 


  void _onPageChanged(int index) {
    setState(() {
      _selectedPageIndex = index;
    });

  }

  //TODO: glass widgets need abstract class
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: MyAppBar(),
      bottomSheet: MiniPlayerSheet(),
      bottomNavigationBar: ClipRect(
      child: LiquidGlassLens(
        style: LiquidGlassStyle(
          shape: LiquidGlassShape.continuousRoundedRectangle(cornerRadius: 0), 
          appearance: LiquidGlassAppearance(
            color: const Color(0x4DFFFFFF), 
            blur: const LiquidGlassBlur(sigmaX: 18, sigmaY: 18),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.black.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
          ),
          child: NavigationBar(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            indicatorColor: const Color.fromARGB(78, 158, 158, 158),
            selectedIndex: _selectedPageIndex,
            onDestinationSelected: _onDestinationSelected,
            destinations: [
              NavigationDestination(icon: Icon(Icons.music_note), label: 'Songs'),
              NavigationDestination(icon: Icon(Icons.playlist_play), label: 'Playlists'),
              NavigationDestination(icon: Icon(Icons.queue_music), label: "Queue"),
              NavigationDestination(icon: Icon(Icons.favorite), label: 'Favorites'),
            ],
          ),
        
        ),
      ),
    ),
      // TODO: Consumers in Specific Pages
      body: Consumer2<SongModel, SongPlayer>(
        builder: (context, songModel, songPlayer, child) => PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: [
              AvailableSongsView(),
              PlaylistListingPage(songModel: songModel),
              SongListView(list: songPlayer.songQueueList),
              FavoritesView(),
            ],
          ),
      )
    );

  }
}






class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<FavoriteModel, SongModel>(
      builder: (context, favoriteModel, songModel, child) => 
        SongListView(list: favoriteModel.fetchFavorites(songModel))
    );
  }
}

class AvailableSongsView extends StatelessWidget  {

  @override
  Widget build(BuildContext context) {
    return Consumer<SongModel>(
      builder: (context, songModel, child) => 
        SongListView(list: songModel.availableSongs),
    );
  }
}

