import 'package:flutter/material.dart';

import 'glassWidget.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {

  MyAppBar({
    super.key, 
    this.title = 'YetAnotherMusicPlayer',
    this.automaticallyImplyLeading = false,
    this.leading
  });

  final String title;
  final bool automaticallyImplyLeading;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return GlassWidget(
      child: AppBar(
        title: Text(title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: automaticallyImplyLeading,
        leading: leading,
      )
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

}

