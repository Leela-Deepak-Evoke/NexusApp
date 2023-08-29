import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app/screens/forum/forum_screen_large.dart';
import 'package:evoke_nexus_app/app/screens/forum/forum_screen_medium.dart';
import 'package:evoke_nexus_app/app/screens/forum/forum_screen_small.dart';
import 'package:evoke_nexus_app/app/screens/responsive/responsive_layout.dart';

class ForumScreen extends StatelessWidget {
  const ForumScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      smallScreenLayout: ForumScreenSmall(),
      mediumScreenLayout: ForumScreenMedium(),
      largeScreenLayout: ForumScreenLarge(),
    );
  }
}
