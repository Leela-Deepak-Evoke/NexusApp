


import 'package:flutter/material.dart';

class MobileAppNavTopBar extends StatelessWidget implements PreferredSizeWidget {
  final bool canPost;
  final double height;

  const MobileAppNavTopBar(
      {super.key, required this.canPost,  this.height = kToolbarHeight,});
  @override
  Widget build(BuildContext context) {
    return AppBar(
          backgroundColor: Colors.red,
    );
  }
 
 @override
  Size get preferredSize => Size.fromHeight(height);
}



