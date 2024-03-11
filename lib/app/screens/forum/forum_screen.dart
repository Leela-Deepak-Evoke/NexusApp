import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app/screens/forum/forum_screen_large.dart';
import 'package:evoke_nexus_app/app/screens/forum/forum_screen_medium.dart';
import 'package:evoke_nexus_app/app/screens/forum/forum_screen_small.dart';
import 'package:evoke_nexus_app/app/screens/responsive/responsive_layout.dart';

class ForumScreen extends StatelessWidget {
  bool? isFromHomePage;

  ForumScreen({Key? key, this.isFromHomePage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      smallScreenLayout: ForumScreenSmall(isFromHomePage: isFromHomePage),
      mediumScreenLayout: ForumScreenMedium(),
      largeScreenLayout: ForumScreenLarge(),
    );
  }
}



