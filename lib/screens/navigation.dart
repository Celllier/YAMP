import 'package:yamp/data/song.dart';
import 'package:yamp/data/songPlayer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/favorite.dart';
import 'common/common.dart';
import 'common/miniPlayer.dart';
import 'songList.dart';
import 'playlist.dart';
import 'common/glassWidget.dart';


//TODO: change name
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

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

  Widget _buildNavigationBar() {
    return  NavigationBar(
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
    );
  }


  Widget _buildPageView() {
    return Consumer2<SongModel, SongPlayer>(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: MyAppBar(),
      bottomSheet: MiniPlayerSheet(),
      bottomNavigationBar: GlassWidget(child: _buildNavigationBar()),
      body: _buildPageView()
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

class AvailableSongsView extends StatelessWidget {

  const AvailableSongsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SongModel>(
      builder: (context, songModel, child) => 
        SongListView(list: songModel.availableSongs),
    );
  }
}

