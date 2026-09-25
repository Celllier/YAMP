import 'package:yamp/data/order/order.dart';
import 'package:provider/provider.dart';


import 'package:flutter/material.dart';
import 'package:yamp/data/song.dart';
import 'package:yamp/data/orderableSongList.dart';

class OrderButton extends StatelessWidget {

  final OrderableSongList songList;

  final List<OrderStrategy> order = const [
    OrderByNameAsc(),
    OrderByNameDesc(),
    OrderDurationAsc(),
    OrderDurationDesc(),
    OrderRandom(),
  ];

  const OrderButton({super.key, required this.songList});

  void _toggleMenu(MenuController controller) {
    if (controller.isOpen) {
      controller.close();
    } else {
      controller.open();
    }
  }

  List<Widget> _getMenuChildren(BuildContext context) {
    SongModel songModel = context.read<SongModel>();
    return <Widget>[
      for (final OrderStrategy orderEntry in order)
        MenuItemButton(
          onPressed: () {
            songList.sort(orderEntry, songModel);
          },
          child: Text(orderEntry.name),
        )
    ];
  }


  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      menuChildren: _getMenuChildren(context),
      builder: (_, controller, _) =>
        IconButton(
          onPressed: () => _toggleMenu(controller),
          icon: Icon(Icons.sort)
        ) 
    );
  }
  
}