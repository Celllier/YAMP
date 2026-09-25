import 'package:yamp/data/order/order.dart';
import 'package:provider/provider.dart';


import 'package:flutter/material.dart';
import 'package:yamp/data/song.dart';
import 'package:yamp/screens/common/orderableSongList.dart';

class OrderButton extends StatelessWidget {

  final OrderableSongList songList;

  final List<OrderStrategy> order = const [
    OrderByNameAsc(),
    OrderByNameDesc(),
    OrderDurationAsc(),
    OrderDurationDesc(),
    OrderRandom(),
  ];

  OrderButton({super.key, required this.songList});


  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      menuChildren: <Widget>[
        for (final OrderStrategy orderEntry in order)
          MenuItemButton(
            onPressed: () {
              songList.sort(orderEntry, context.read<SongModel>());
            },
            child: Text(orderEntry.name),
          )
      ],

      builder: (_, controller, _) =>
        IconButton(
          onPressed: () => {
            if (controller.isOpen) controller.close()
            else controller.open()
          },
           icon: Icon(Icons.sort)
          ) 
    );
  }
  
}