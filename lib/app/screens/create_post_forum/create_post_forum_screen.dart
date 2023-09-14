import 'package:evoke_nexus_app/app/screens/create_post_forum/create_post_forum_screen_large.dart';
import 'package:evoke_nexus_app/app/screens/create_post_forum/create_post_forum_screen_medium.dart';
import 'package:evoke_nexus_app/app/screens/create_post_forum/create_post_forum_screen_small.dart';
import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app/screens/responsive/responsive_layout.dart';

class CreatePostForumScreen extends StatelessWidget {
  const CreatePostForumScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      smallScreenLayout: CreatePostForumScreenSmall(),
      mediumScreenLayout: CreatePostForumScreenMedium(),
      largeScreenLayout: CreatePostForumScreenLarge(),
    );
  }
}
