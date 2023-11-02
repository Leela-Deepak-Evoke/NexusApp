import 'package:evoke_nexus_app/app/models/feed.dart';
import 'package:evoke_nexus_app/app/provider/user_service_provider.dart';
import 'package:evoke_nexus_app/app/screens/create_post_feed/widgets/postfeed_mobile_view.dart';
import 'package:evoke_nexus_app/app/screens/create_post_forum/widgets/post_forum_mobile_view.dart';
import 'package:evoke_nexus_app/app/widgets/common/round_action_view.dart';
import 'package:evoke_nexus_app/app/widgets/layout/mobile_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreatePostFeedScreenSmall extends ConsumerStatefulWidget {
     Feed? feedItem; // Add a parameter for the Feed item
   bool? isEditFeed;

  CreatePostFeedScreenSmall({Key? key,  this.feedItem, this.isEditFeed}) : super(key: key);

  @override
  ConsumerState<CreatePostFeedScreenSmall> createState() => _CreatePostFeedScreenSmallState();
}

class _CreatePostFeedScreenSmallState extends ConsumerState<CreatePostFeedScreenSmall> {
  @override
  Widget build(BuildContext context) {
        final feedItem = widget.feedItem;
         final isEditFeed = widget.isEditFeed;

    String rightActionTitle = 'Select Category';
      GlobalKey<PostFeedsMobileViewState> childKey = GlobalKey();

    final userAsyncValue = ref.watch(fetchUserProvider);
    return userAsyncValue.when(
      data: (data) {
         return    MobileLayout(
          title: "Post Feed",
          user: data,
          hasBackAction: true,
          hasRightAction: true,

          topBarButtonAction: () {  

          },
          backButtonAction: () {
            Navigator.pop(context);
          },
          rightChildWiget: RoundedActionView(onPressed:() {
            childKey.currentState?.onCategorySelected();
          }
          , title: rightActionTitle),
          child: PostFeedsMobileView(key: childKey, user: data,slectedCategory:  rightActionTitle, feedItem: feedItem, isEditFeed: isEditFeed),

        );
  }, 
    loading: () => const Center(
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) {
        // Handle the error case if needed
        return Text('An error occurred: $error');
      },
  );
  }

  }


