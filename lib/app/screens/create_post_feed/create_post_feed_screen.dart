import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app/screens/create_post_feed/create_post_feed_screen_large.dart';
import 'package:evoke_nexus_app/app/screens/create_post_feed/create_post_feed_screen_medium.dart';
import 'package:evoke_nexus_app/app/screens/create_post_feed/create_post_feed_screen_small.dart';
import 'package:evoke_nexus_app/app/screens/responsive/responsive_layout.dart';

class CreatePostFeedScreen extends StatelessWidget {
  const CreatePostFeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      smallScreenLayout: CreatePostFeedScreenSmall(),
      mediumScreenLayout: CreatePostFeedScreenMedium(),
      largeScreenLayout: CreatePostFeedScreenLarge(),
    );
  }
}
