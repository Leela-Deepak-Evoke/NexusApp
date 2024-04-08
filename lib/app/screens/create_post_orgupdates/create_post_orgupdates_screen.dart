import 'package:evoke_nexus_app/app/models/org_updates.dart';
import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app/screens/create_post_orgupdates/create_post_orgupdates_screen_large.dart';
import 'package:evoke_nexus_app/app/screens/create_post_orgupdates/create_post_orgupdates_screen_medium.dart';
import 'package:evoke_nexus_app/app/screens/create_post_orgupdates/create_post_orgupdates_screen_small.dart';
import 'package:evoke_nexus_app/app/screens/responsive/responsive_layout.dart';

class CreatePostOrgUpdatesScreen extends StatelessWidget {
   OrgUpdate? orgUpdateItem; 
   bool? isEditOrgUpdate;
   CreatePostOrgUpdatesScreen({Key? key, this.orgUpdateItem, this.isEditOrgUpdate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      smallScreenLayout: CreatePostOrgUpdatesScreenSmall(orgUpdateItem: orgUpdateItem, isEditOrgUpdate: isEditOrgUpdate),
      mediumScreenLayout: const CreatePostOrgUpdatesScreenMedium(),
      largeScreenLayout: const CreatePostOrgUpdatesScreenLarge(),
    );
  }
}


// class CreatePostFeedScreen extends StatelessWidget {
//   final Feed feedItem; // Change from Feed? to Feed

//   const CreatePostFeedScreen({Key? key, required this.feedItem}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ResponsiveLayout(
//       smallScreenLayout: CreatePostFeedScreenSmall(feedItem: feedItem), // Pass the feedItem here
//       mediumScreenLayout: CreatePostFeedScreenMedium(),
//       largeScreenLayout: CreatePostFeedScreenLarge(),
//     );
//   }
// }
