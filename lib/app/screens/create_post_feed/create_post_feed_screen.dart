import 'package:evoke_nexus_app/app/models/feed.dart';
import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app/screens/create_post_feed/create_post_feed_screen_large.dart';
import 'package:evoke_nexus_app/app/screens/create_post_feed/create_post_feed_screen_medium.dart';
import 'package:evoke_nexus_app/app/screens/create_post_feed/create_post_feed_screen_small.dart';
import 'package:evoke_nexus_app/app/screens/responsive/responsive_layout.dart';

class CreatePostFeedScreen extends StatelessWidget {
   Feed? feedItem; 
   bool? isEditFeed;
   CreatePostFeedScreen({Key? key, this.feedItem, this.isEditFeed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      smallScreenLayout: CreatePostFeedScreenSmall(feedItem: feedItem, isEditFeed: isEditFeed),
      mediumScreenLayout: const CreatePostFeedScreenMedium(),
      largeScreenLayout: const CreatePostFeedScreenLarge(),
    );
  }
}
