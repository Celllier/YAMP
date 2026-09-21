import 'package:flutter/material.dart';
import 'package:yamp/screens/common/glassWidget.dart';

import 'package:provider/provider.dart';
import 'package:yamp/screens/common/orderableSongList.dart';
import '../data/songPlayer.dart';

import 'common/common.dart';
import 'playlist.dart';
import '../data/song.dart';
import '../data/favorite.dart';
import 'common/miniPlayer.dart';
import 'songList.dart';


class AdaptiveLayout extends StatefulWidget {
  static const int largeScreenMinWidth = 900;

  const AdaptiveLayout({super.key});

  @override
  State<AdaptiveLayout> createState() => _AdaptiveLayoutState(); 
}


class _AdaptiveLayoutState extends State<AdaptiveLayout> {

  final PageController _pageController = PageController();
  int selectedIndex = 0;

  final pages =  [
    {'page': AvailableSongsView(),  'icon': Icon(Icons.music_note),    'text': 'Songs'},
    {'page': PlaylistListingPage(), 'icon': Icon(Icons.playlist_play), 'text': 'Playlists'},
    {'page': QueuedSongsView(),     'icon': Icon(Icons.queue_music),   'text': 'Queue'},
    {'page': FavoritesView(),       'icon': Icon(Icons.favorite),      'text': 'Favorites'},
  ];

  void _onDestinationSelected(int index) {
    setState(() {
      selectedIndex = index;
    });

    _pageController.animateToPage(
      selectedIndex, 
      duration: Duration(milliseconds: 350),
      curve: Curves.easeOutQuint
    );
  } 


  void _onPageChanged(int index) {
    setState(() {
      selectedIndex = index;
    });
  }


   Widget? _buildNavigationBar(bool isLargeScreen) {
    return isLargeScreen 
      ? null
      : GlassWidget(
          child: NavigationBar(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            indicatorColor: _AdaptiveLayoutState.indicatorColor,
            selectedIndex: selectedIndex,
            onDestinationSelected: _onDestinationSelected,
            destinations: [
              for (final pageEntry in pages)
                NavigationDestination(
                  icon: pageEntry['icon'] as Icon,
                  label: pageEntry['text'] as String
                )
            ],
        ),
    );
  }

  Widget _buildNavigationRail() {
    return Row(
      children: [
        NavigationRail(
          selectedIndex: selectedIndex,
          onDestinationSelected: _onDestinationSelected,
          indicatorColor: _AdaptiveLayoutState.indicatorColor,
          labelType: NavigationRailLabelType.all,
          destinations: [
            for (final pageEntry in pages)
              NavigationRailDestination(
                icon: pageEntry['icon'] as Icon,
                label: Text(pageEntry['text'] as String)
              )
          ],
        ),

        const VerticalDivider(thickness: 1, width: 1),
      ],
    );
  }


  Widget _buildPageView() {
    return PageView(
      controller: _pageController,
      onPageChanged: _onPageChanged,
      children: [
        for (final pageEntry in pages)
          pageEntry['page'] as Widget
      ],
    );
  }

  
  Widget _buildContent(bool isLargeScreen) {
    return Row(
      children: [
        if (isLargeScreen) 
          _buildNavigationRail(),

        Expanded(
          child: Stack(
            alignment: AlignmentGeometry.bottomCenter,
            children: [
              _buildPageView(),
              Padding(
                padding: EdgeInsetsGeometry.only(bottom: 30),
                child: SizedBox(
                  width: 700,
                  child: MiniPlayerSheet(),
                )  
              )
            ],
          )
        )
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLargeScreen = constraints.maxWidth > AdaptiveLayout.largeScreenMinWidth;

        return Scaffold(
          appBar: MyAppBar(),
          //bottomSheet: Container(padding: EdgeInsets.only(bottom: 30), child: MiniPlayerSheet(), color: Colors.red) ,
          bottomNavigationBar: _buildNavigationBar(isLargeScreen),
          body: _buildContent(isLargeScreen)
        );
      }
    );
  }

  static Color get indicatorColor => Color.fromARGB(78, 158, 158, 158);

}



class FavoritesView extends StatelessWidget {
  
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<FavoriteModel, SongModel>(
      builder: (context, favoriteModel, songModel, child) => 
        DefaultSongListView(songList: OrderableSongList(songs: favoriteModel.fetchFavorites(songModel)))
    );
  }
}

class AvailableSongsView extends StatelessWidget {

  const AvailableSongsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:  Consumer<SongModel>(
      builder: (context, songModel, child) => 
        DefaultSongListView(songList: OrderableSongList(songs: songModel.availableSongs)),
    )
    ) ;
    
   
  }
}

class QueuedSongsView extends StatelessWidget {

  const QueuedSongsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SongPlayer>(
      builder: (context, songPlayer, child) =>
        DefaultSongListView(songList: OrderableSongList(songs: songPlayer.songQueueList), isOrderable: false,)
    );
  }
}